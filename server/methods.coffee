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
  # 使用数字作为数据库记录（文档）的id
  'create_root': (options) ->
    if not @userId?
      throw new Meteor.Error 403, '想开坑，先登录'
    check options,
      title: NonEmptyString,
      description: NonEmptyString
    Roots.insert
      title: options.title,
      description: options.description,
      _id: Roots.find().count().toString()
      author: @userId
      visits: 0
      timestamp: (new Date).getTime()
  # 开分支的方法调用
  'create_node': (options) ->
    if not @userId?
      throw new Meteor.Error 403, '想开分支，先登录'
    check options,
      root_id: RootID,
      title: NonEmptyString,
      contents: NonEmptyString
    Nodes.insert
      root_id: options.root_id,
      title: options.title,
      contents: options.contents,
      _id: Nodes.find().count().toString()
      author: @userId
      visits: 0
      timestamp: (new Date).getTime()

# Firefox有史以来最大的坑…………
# 欺负我不用about:config是吧？！！欺负Meteor用IPv6是吧？！！！尼玛！！！！！！
# http://en.kioskea.net/forum/affich-57878-firefox-connection-interrupted
Meteor.startup ->
  WebApp.connectHandlers.use (req, res, next) ->
    res.setHeader 'Access-Control-Allow-Origin', '*'
    next()
