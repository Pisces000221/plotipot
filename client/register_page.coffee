Session.setDefault 'register_err_msg', ''

check_password = ->
  # 检查两次密码是否相同
  same = document.getElementById('password_again').value is document.getElementById('password').value
  Session.set 'register_err_msg', if same then '' else '两次输入的密码不同，检查一下是否手抖'
  same

Template.register_panel.events
  'blur #username': ->
    # 检查用户名是否已经被使用
    Meteor.call 'check_username_availability', document.getElementById('username').value, (err, available) ->
      Session.set 'register_err_msg', if available then '' else '用户名已存在 T^T 换一个吧'
  'click #btn_register': ->
    if not check_password() then return
    # 创建新用户
    Accounts.createUser
      username: document.getElementById('username').value
      email: document.getElementById('email').value
      password: document.getElementById('password').value, (err) ->
        # 创建成功/失败时的回调
        if err isnt undefined
          Session.set 'register_err_msg', err.toString()
        else
          Session.set 'username', Meteor.user().username
          Router.go '/'
  'blur #password_again': -> check_password()
  'click #btn_goto_login': -> Router.go '/login'

Template.register_panel.helpers
  'err_message': -> Session.get 'register_err_msg'
