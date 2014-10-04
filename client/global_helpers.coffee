######## 全局helpers ########
Session.setDefault 'username', ''

# Blaze你又调皮了～～～～只把< > &之类的给HTML编码一下，就是不编码换行符～～
# 要不下次给Meteor发个PR过去？
# https://github.com/meteor/meteor/blob/master/packages/blaze/preamble.js
Template.registerHelper 'description_encoded', ->
  (html_encode @description).replace /\n/g, '<br>'
Template.registerHelper 'author_name', -> Meteor.users.findOne(@author).username
Template.registerHelper 'timestamp_readable', -> (new Date @timestamp).toLocaleString()
Template.registerHelper 'likes', -> @liked_by.length

Template.registerHelper 'logged_in', -> Meteor.userId()?
Template.registerHelper 'logging_in', -> Meteor.loggingIn()
Template.registerHelper 'cur_username', ->
  stored = Session.get 'username'
  if Meteor.userId()?
    if stored isnt '' then stored
    else name = Meteor.user().username; Session.set 'username', name; name
  else ''

######## 全局方法 ########
# 加载Javascript和样式表的方法
window.load_script = (script_url) ->
  script_tag = document.createElement 'script'
  script_tag.type = 'text/javascript'
  script_tag.src = script_url
  document.head.appendChild script_tag

window.load_stylesheet = (css_url) ->
  css_tag = document.createElement 'link'
  css_tag.rel = 'stylesheet'
  css_tag.href = css_url
  document.head.appendChild css_tag

# HTML编码函数，懒得用RegExp了……在Firefox和QupZilla下均可以工作。
# http://blog.csdn.net/cuixiping/article/details/7846806
html_encode = (s) ->
  div = document.createElement 'div'
  div.appendChild document.createTextNode s
  div.innerHTML
