Session.setDefault 'username', ''

Template.registerHelper 'logged_in', -> Meteor.userId() isnt null
Template.registerHelper 'logging_in', -> Meteor.loggingIn()
Template.registerHelper 'cur_username', -> Session.get 'username'

Template.header.events
  'click #topbar_btn_register': -> Router.go '/register'
  'click #topbar_btn_login': -> Router.go '/login'
  'click #topbar_btn_logout': -> Meteor.logout()

# 由于Session会在每次页面重新加载时重设，我们用一个Session记录是否加载过AmazeUI
Session.setDefault 'amazeui_js_loaded', 'of course not'

Template.header.created = ->
  # http://stackoverflow.com/questions/2741441/
  # 防止重复添加
  if Session.equals 'amazeui_js_loaded', 'absolutely' then return
  # http://stackoverflow.com/questions/23599997/
  # 在模板刚创建时（渲染之前）加入AmazeUI的Javascript文件
  # 话说Meteor实在太坑爹了，自动加载Javascript的时候由于template会先于其它文件加载
  # 导致AmazeUI的库会在模板渲染完成之后载入，于是所有的效果（包括下拉菜单等）都木有了……
  #  <script type='text/javascript' src='amazeui/zepto.min.js'></script>
  #  <script type='text/javascript' src='amazeui/amui.min.js'></script>
  script_tag = document.createElement 'script'
  script_tag.type = 'text/javascript'
  script_tag.src = 'amazeui/zepto.min.js'
  document.head.appendChild script_tag
  script_tag = document.createElement 'script'
  script_tag.type = 'text/javascript'
  script_tag.src = 'amazeui/amui.min.js'
  document.head.appendChild script_tag
  Session.set 'amazeui_js_loaded', 'absolutely'
