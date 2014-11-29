NonEmptyString = Match.Where (x) ->
  check x, String
  x.length isnt 0

RootID = Match.Where (x) ->
  check x, String
  (Pots.find x).count() is 1

LeafID = Match.Where (x) ->
  check x, String
  (Leaves.find x).count() is 1

Coordinate = Match.Where (p) ->
  check p.x, Number
  check p.y, Number
  0 <= p.x <= 1 and 0 <= p.y <= 1

Meteor.methods
  # 访问计数器
  'hit_pot': (id) -> Pots.update id, $inc: visits: 1
  'hit_leaf': (id) -> Leaves.update id, $inc: visits: 1
  # 开坑的方法调用
  # 使用数字作为数据库记录（文档）的id，两个方法均返回创建出来的id
  'create_pot': (options) ->
    if not @userId?
      throw new Meteor.Error 403, '想开坑吗？登录就给你开'
    check options,
      title: NonEmptyString
      description: NonEmptyString
      tags: Match.Optional([NonEmptyString])
    options.tags ?= []
    options.id = (Pots.find().count() + 1).toString()
    for t in options.tags
      d = Tags.findOne name: t
      # Please.js 生成随机颜色
      colour = Please.make_color()  #'#b0cfd2'
      Tags.insert {_id: (Tags.find().count() + 1).toString(), name: t, colour: colour, pots: []} if not d?
      Tags.update {name: t}, {$addToSet: pots: options.id}
    Pots.insert
      title: options.title
      description: options.description
      _id: options.id
      author: @userId
      visits: 0
      liked_by: []
      tags: options.tags
      timestamp: (new Date).getTime()
      mainline: []
  # 开分支的方法调用
  'create_leaf': (options) ->
    if not @userId?
      throw new Meteor.Error 403, '想开分支吗？登录就给你开'
    check options,
      pot_id: RootID
      title: NonEmptyString
      contents: NonEmptyString
    Leaves.insert
      pot_id: options.pot_id
      title: options.title
      contents: options.contents
      _id: (Leaves.find().count() + 1).toString()
      parents: []
      children: []
      author: @userId
      visits: 0
      liked_by: []
      timestamp: (new Date).getTime()
      comments: []
  # 把两个节点链接起来（其实就是“我要你们在一起”……）
  'link_leaves': (parent_id, child_id) ->
    # check parent_id, NodeID
    # check child_id, NodeID
    check parent_id, String
    check child_id, String
    a = Leaves.findOne parent_id
    b = Leaves.findOne child_id
    if not a? or not b?
      throw new Meteor.Error 403, '找不到你要的节点 T^T ' + ("(#{parent_id})" if not a?) + ("(#{child_id})" if not b?)
    else if parent_id is child_id
      throw new Meteor.Error 403, '自己不可以连到自己'
    else if a.author isnt @userId and b.author isnt @userId
      throw new Meteor.Error 403, '不要随便乱动别人的东西喔~~'
    else if a.pot_id isnt b.pot_id
      throw new Meteor.Error 403, '本非同根生，相（连）何太急？？'
    Leaves.update parent_id, $addToSet: children: child_id
    Leaves.update child_id, $addToSet: parents: parent_id
  # 爱就要大声说出来！！
  'toggle_like_leaf': (leaf_id) ->
    if not @userId?
      throw new Meteor.Error 403, '想赞吗？登录就让你赞'
    l = Leaves.findOne leaf_id
    m = {}
    if l.liked_by.indexOf(@userId) is -1 then m = $push: liked_by: @userId
    else m = $pull: liked_by: @userId
    Leaves.update leaf_id, m
  # 写批注/发评论
  'post_comment': (options) ->
    if not @userId?
      throw new Meteor.Error 403, '想发评论吗？登录就给你发'
    check options,
      leaf_id: LeafID
      text: NonEmptyString
      pos: Coordinate
    new_id = Comments.insert
      _id: (Comments.find().count() + 1).toString()
      text: options.text
      pos: options.pos
      author: @userId
      liked_by: []
      timestamp: (new Date).getTime()
    console.log new_id
    Leaves.update options.leaf_id, $push: { comments: new_id }
