Meteor.subscribe 'roots'

Template.all_roots_display.helpers
  'root_list': -> Roots.find()
