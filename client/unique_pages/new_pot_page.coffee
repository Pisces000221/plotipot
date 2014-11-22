Session.setDefault 'new_pot_in_progress', false

Template.new_pot_panel.helpers
  'in_progress': -> Session.get 'new_pot_in_progress'

Template.new_pot_panel.events
  'click #btn_newpot_submit': ->
    # http://stackoverflow.com/questions/650022/how-do-i-split-a-string-with-multiple-separators-in-javascript
    tags = document.getElementById('tags').value
    tags = tags.split /[,，\.]+/
    tags = (t.trim() for t in tags)
    Session.set 'new_pot_in_progress', true
    Meteor.call 'create_pot',
      title: document.getElementById('title').value
      description: document.getElementById('description').value
      tags: tags
    , (err, result) ->
      if err? then alert err.toString()
      # result是创建的坑的id
      else Router.go '/pot_details/' + result
      Session.set 'new_pot_in_progress', false
