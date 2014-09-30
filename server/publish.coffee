# 在这里向客户端发布所有的数据库

Meteor.publish 'roots', -> Roots.find()
Meteor.publish 'nodes', (root_id) -> Nodes.find root_id: root_id
Meteor.publish 'all_users', -> Meteor.users.find {}, {fields: {profile: 1, username: 1}}
