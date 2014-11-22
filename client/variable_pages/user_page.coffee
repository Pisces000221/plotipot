Template.user_page.helpers
  'tas_pots': -> Pots.find author: @_id
  'tas_leafs': -> Meteor.subscribe 'leaves', '.' + @_id; Leaves.find()
