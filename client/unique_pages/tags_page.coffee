Meteor.subscribe 'tags'

Template.tags_display.helpers
  'all_tags': -> Tags.find()
  'cur_tag_size': -> 20 + Math.round(Math.sqrt @roots.length)
