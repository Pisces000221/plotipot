Template.chapter.helpers
  'root_title': -> Roots.findOne(@root_id).title
  'parents_count': -> @parents.length
  'children_count': -> @children.length
  'current_chapter': -> Nodes.findOne @toString()

  'rendered_contents': -> marked @contents

  'inc_visits': ->
    if @_id and not Session.get('counted_chapter_' + @_id)
      Meteor.call 'hit_chapter', @_id
      Session.set ('counted_chapter_' + @_id), true
    ''

Template.chapter.events
  'click #btn_fork': -> Router.go "/create_node/#{@root_id}/#{@_id}"
  'click #btn_merge': -> Router.go "/merge_node/#{@root_id}/#{@_id}"
