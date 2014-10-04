Session.setDefault 'username', ''

# HTML编码函数，懒得用RegExp了……在Firefox和QupZilla下均可以工作。
# http://blog.csdn.net/cuixiping/article/details/7846806
html_encode = (s) ->
  div = document.createElement 'div'
  div.appendChild document.createTextNode s
  div.innerHTML
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

Template.header.events
  'click #topbar_btn_register': -> Router.go '/register'
  'click #topbar_btn_login': -> Router.go '/login'
  'click #topbar_btn_logout': -> Meteor.logout()

# 由于Session会在每次页面重新加载时重设，我们用一个Session记录是否加载过AmazeUI
Session.setDefault 'amazeui_js_loaded', 'of course not'

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

Template.header.created = ->
  # http://stackoverflow.com/questions/2741441/
  # 防止重复添加
  if Session.equals 'amazeui_js_loaded', 'absolutely' then return
  # http://stackoverflow.com/questions/23599997/
  # 在模板刚创建时（渲染之前）加入AmazeUI的Javascript文件
  # 话说Meteor实在太坑爹了，自动加载Javascript的时候由于template会先于其它文件加载
  # 导致AmazeUI的库会在模板渲染完成之后载入，于是所有的效果（包括下拉菜单等）都木有了……
  #  <script type='text/javascript' src='/amazeui/zepto.min.js'></script>
  # staticfile.org上的Zepto不科学，最新版是1.0rc1……
  window.load_script 'http://cdn.staticfile.org/zepto/1.1.4/zepto.min.js'
  window.load_script 'http://cdn.staticfile.org/amazeui/1.0.0-beta2/js/amazeui.min.js'
  Session.set 'amazeui_js_loaded', 'absolutely'
