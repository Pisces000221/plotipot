NonEmptyString = Match.Where (x) ->
  check x, String
  x.length isnt 0

RootID = Match.Where (x) ->
  check x, String
  (Roots.find x).count() is 1

Meteor.methods
  'check_username_availability': (username) -> Meteor.users.find(username: username).count() is 0
  # TODO: Remove this before production
  'remove_all_users': () -> console.log "#{Meteor.users.find().count()} user(s) deleted"; Meteor.users.remove({})
  # 开坑的方法调用
  # 使用数字作为数据库记录（文档）的id，两个方法均返回创建出来的id
  'create_root': (options) ->
    if not @userId?
      throw new Meteor.Error 403, '想开坑吗？登录就给你开'
    check options,
      title: NonEmptyString
      description: NonEmptyString
    Roots.insert
      title: options.title
      description: options.description
      _id: Roots.find().count().toString()
      author: @userId
      visits: 0
      liked_by: []
      timestamp: (new Date).getTime()
  # 开分支的方法调用
  'create_node': (options) ->
    if not @userId?
      throw new Meteor.Error 403, '想开分支吗？登录就给你开'
    check options,
      root_id: RootID
      title: NonEmptyString
      contents: NonEmptyString
    Nodes.insert
      root_id: options.root_id
      title: options.title
      contents: options.contents
      _id: Nodes.find().count().toString()
      parents: []
      children: []
      author: @userId
      visits: 0
      liked_by: []
      timestamp: (new Date).getTime()
  # 把两个节点链接起来（其实就是“我要你们在一起”……）
  'link_nodes': (parent_id, child_id) ->
    # check parent_id, NodeID
    # check child_id, NodeID
    check parent_id, String
    check child_id, String
    a = Nodes.findOne parent_id
    b = Nodes.findOne child_id
    if not a? or not b?
      throw new Meteor.Error 403, '找不到你要的节点 T^T ' + ("(#{parent_id})" if not a?) + ("(#{child_id})" if not b?)
    else if parent_id is child_id
      throw new Meteor.Error 403, '自己不可以连到自己'
    else if a.author isnt @userId and b.author isnt @userId
      throw new Meteor.Error 403, '不要随便乱动别人的东西喔~~'
    else if a.root_id isnt b.root_id
      throw new Meteor.Error 403, '为何把两篇不同根的章节连起来？！'
    Nodes.update parent_id, $addToSet: children: child_id
    Nodes.update child_id, $addToSet: parents: parent_id

# Firefox有史以来最大的坑…………
# 欺负我不用about:config是吧？！！欺负Meteor用IPv6是吧？！！！尼玛！！！！！！
# http://en.kioskea.net/forum/affich-57878-firefox-connection-interrupted
Meteor.startup ->
  WebApp.connectHandlers.use (req, res, next) ->
    res.setHeader 'Access-Control-Allow-Origin', '*'
    next()
