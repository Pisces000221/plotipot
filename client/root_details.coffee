Template.root_details.helpers
  'my_nodes': -> Meteor.subscribe 'nodes', @_id; Nodes.find()

Template.root_details.events
  'click #btn_create_node': -> Router.go '/create_node/' + @_id
