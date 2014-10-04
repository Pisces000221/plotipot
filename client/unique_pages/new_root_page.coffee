Template.new_root_panel.events
  'click #btn_newroot_submit': ->
    Meteor.call 'create_root',
      title: document.getElementById('title').value
      description: document.getElementById('description').value
    , (err) -> if err? then alert err.toString()
    # TODO: 转到新建的坑的页面
    Router.go '/'
