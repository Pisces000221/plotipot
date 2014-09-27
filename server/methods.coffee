Meteor.methods
  'check_username_availability': (username) -> Meteor.users.find(username: username).count() is 0
  # TODO: Remove this before production
  'remove_all_users': () -> console.log "#{Meteor.users.find().count()} user(s) deleted"; Meteor.users.remove({})
