Session.setDefault 'login_err_msg', ''

Template.login_page.events
  'click #btn_goto_register': -> Router.go '/register'
  'click #btn_login': ->
    Meteor.loginWithPassword document.getElementById('username').value, document.getElementById('password').value, (err) ->
      if err isnt undefined
        Session.set 'login_err_msg', err.toString()
      else
        Session.set 'login_err_msg', ''
        Session.set 'username', Meteor.user().username
        return_to = window.location.search
        return_to = return_to.substr(return_to.indexOf('=') + 1)
        Router.go unescape return_to

Template.login_panel.helpers
  'err_message': -> Session.get 'login_err_msg'
