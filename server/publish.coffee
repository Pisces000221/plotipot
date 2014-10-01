# 在这里向客户端发布所有的数据库

Meteor.publish 'roots', -> Roots.find()
Meteor.publish 'nodes', (id) ->
  if id.charAt(0) is '.' then Nodes.find id.substr(1)
  else Nodes.find root_id: id
Meteor.publish 'all_users', -> Meteor.users.find {}, {fields: {profile: 1, username: 1}}
