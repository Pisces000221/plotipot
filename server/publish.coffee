###
TODO: publish something here

Meteor.publish {
  '<database>', -> <Database>.find()
}
###

Meteor.publish 'roots', -> Roots.find()
Meteor.publish 'all_users', -> Meteor.users.find {}, {fields: {profile: 1, username: 1}}
