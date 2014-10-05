Meteor.subscribe 'tags'

Template.tags_display.helpers
  'all_tags': -> Tags.find()
  'roots_count': -> @roots.length
