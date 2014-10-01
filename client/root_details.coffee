Session.setDefault 'cur_root_id', ''

Template.root_details.helpers
  'my_nodes': ->
    Session.set 'cur_root_id', @_id
    Nodes.find()
  'cur_root_id': -> Session.get 'cur_root_id'

Template.root_details.events
  'click #btn_create_node': -> Router.go '/create_node/' + @_id

editor = undefined
Template.create_node.rendered = ->
  editor = new Editor()
  editor.render()

Template.create_node.events
  'click #btn_newnode_submit': ->
    Nodes.insert
      root_id: @_id
      title: document.getElementById('title').value
      contents: editor.codemirror.getValue()
      author: Meteor.userId()
    Router.go '/root_details/' + @_id
