Session.setDefault 'new_root_in_progress', false

Template.new_root_panel.helpers
  'in_progress': -> Session.get 'new_root_in_progress'

Template.new_root_panel.events
  'click #btn_newroot_submit': ->
    # http://stackoverflow.com/questions/650022/how-do-i-split-a-string-with-multiple-separators-in-javascript
    tags = document.getElementById('tags').value
    tags = tags.split /[,，\.]+/
    tags = (t.trim() for t in tags)
    Session.set 'new_root_in_progress', true
    Meteor.call 'create_root',
      title: document.getElementById('title').value
      description: document.getElementById('description').value
      tags: tags
    , (err) ->
      if err? then alert err.toString()
      # TODO: 转到新建的坑的页面
      else Router.go '/'
      Session.set 'new_root_in_progress', false
