Template.registerHelper 'logged_in', -> Meteor.userId() isnt null
Template.registerHelper 'cur_username', -> Meteor.user().username

Template.header.events
  'click #topbar_btn_home': -> Router.go '/'
  'click #topbar_btn_register': -> Router.go '/register'
  'click #topbar_btn_login': -> Router.go '/login'
  'click #topbar_btn_logout': -> Meteor.logout()

Session.setDefault 'a', ''

Template.header.created = ->
  # http://stackoverflow.com/questions/2741441/
  # 防止重复添加
  if Session.equals 'a', '1' then return
  # http://stackoverflow.com/questions/23599997/
  # 在模板刚创建时（渲染之前）加入AmazeUI的Javascript文件
  # 话说Meteor实在太坑爹了，自动加载Javascript的时候由于template会先于其它文件加载
  # 导致AmazeUI的库会在模板渲染完成之后载入，于是所有的效果（包括下拉菜单等）都木有了……
  #  <script type='text/javascript' src='js/zepto.min.js'></script>
  #  <script type='text/javascript' src='js/amui.min.js'></script>
  script_tag = document.createElement 'script'
  script_tag.id = '__amazeui_zepto_loaded__'
  script_tag.type = 'text/javascript'
  script_tag.src = 'js/zepto.min.js'
  document.head.appendChild script_tag
  script_tag = document.createElement 'script'
  script_tag.id = '__amazeui_amui_loaded__'
  script_tag.type = 'text/javascript'
  script_tag.src = 'js/amui.min.js'
  document.head.appendChild script_tag
  Session.set 'a', '1'
