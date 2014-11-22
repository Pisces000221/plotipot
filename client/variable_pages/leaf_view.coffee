Template.leaf.helpers
  'pot_title': -> Pots.findOne(@pot_id).title
  'parents_count': -> @parents.length
  'children_count': -> @children.length
  'current_leaf': -> Leaves.findOne @toString()

  'rendered_contents': -> marked @contents

  'inc_visits': ->
    if @_id and not Session.get('counted_leaf_' + @_id)
      Meteor.call 'hit_leaf', @_id
      Session.set ('counted_leaf_' + @_id), true
    ''

Template.leaf.events
  'click #btn_fork': -> Router.go "/create_leaf/#{@pot_id}/#{@_id}"
  'click #btn_merge': -> Router.go "/merge_leaf/#{@pot_id}/#{@_id}"
