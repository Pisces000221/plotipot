Template.new_root_panel.events
  'click #btn_newroot_submit': ->
    Roots.insert
      title: document.getElementById('title').value
      description: document.getElementById('description').value
      author: Meteor.userId()
      visits: 0
      timestamp: (new Date).getTime()
    # TODO: 转到新建的坑的页面
    Router.go '/'
