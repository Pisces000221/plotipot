Session.setDefault 'count_valid', true
Template.chapter.rendered = -> Session.set 'count_valid', true

Template.chapter.helpers
  'root_title': -> Roots.findOne(@root_id).title
  'parents_count': -> @parents.length
  'children_count': -> @children.length
  'current_chapter': -> Nodes.findOne @toString()

  'inc_visits': ->
    if @_id and Session.get 'count_valid'
      Meteor.call 'hit_chapter', @_id
      Session.set 'count_valid', false
    ''

Template.chapter.events
  'click #btn_fork': -> Router.go "/create_node/#{@root_id}/#{@_id}"
  'click #btn_merge': -> Router.go "/merge_node/#{@root_id}/#{@_id}"
