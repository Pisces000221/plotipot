Meteor.methods
  'check_username_availability': (username) -> Meteor.users.find(username: username).count() is 0

# Firefox有史以来最大的坑…………
# 欺负我不用about:config是吧？！！欺负Meteor用IPv6是吧？！！！尼玛！！！！！！
# http://en.kioskea.net/forum/affich-57878-firefox-connection-interrupted
Meteor.startup ->
  WebApp.connectHandlers.use (req, res, next) ->
    res.setHeader 'Access-Control-Allow-Origin', '*'
    next()
