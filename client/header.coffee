Template.header.events
  'click #topbar_btn_register': -> Router.go '/register'
  'click #topbar_btn_login': -> Router.go '/login?return_to=' + escape window.location.pathname
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
  #  <script type='text/javascript' src='/amazeui/zepto.min.js'></script>
  # staticfile.org上的Zepto不科学，最新版是1.0rc1……
  window.load_script 'http://cdn.staticfile.org/zepto/1.1.4/zepto.min.js'
  window.load_script 'http://cdn.amazeui.org/amazeui/1.0.1/js/amazeui.min.js'
  Session.set 'amazeui_js_loaded', 'absolutely'
