###
TODO: publish something here

Meteor.publish {
  '<database>', -> <Database>.find()
}
###

Meteor.publish 'roots', -> Roots.find()
