Session.setDefault 'cur_root_id', ''

Template.root_details.helpers
  'my_nodes': ->
    Session.set 'cur_root_id', @_id
    Nodes.find()
  'cur_root_id': -> Session.get 'cur_root_id'

Template.root_details.events
  'click #btn_create_node': -> Router.go '/create_node/' + @_id + '/0'

editor = undefined
Template.create_node.rendered = ->
  editor = new Editor()
  editor.render()

# 下面的方法会导致数据失去互动性(reactivity)
#parent_id = -> if @parent_id? then @parent_id else @parent_id = Session.get 'forking_parent'
Template.create_node.helpers
  'forking_parent_node': -> (Session.get 'forking_parent') isnt '0'
  'parent_node_author': -> (Meteor.users.findOne (Nodes.findOne (Session.get 'forking_parent')).author).username
  'parent_node_title': -> (Nodes.findOne (Session.get 'forking_parent')).title

Template.create_node.events
  'click #btn_newnode_submit': ->
    Meteor.call 'create_node',
      root_id: @_id
      title: document.getElementById('title').value
      contents: editor.codemirror.getValue()
    , (err, result) ->
      # result是新创建的节点的id
      if err? then alert err.toString(); return
      parent_id = Session.get 'forking_parent'
      Meteor.call 'link_nodes', parent_id, result if parent_id isnt '0'
    Router.go '/root_details/' + @_id
