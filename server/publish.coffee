# 在这里向客户端发布所有的数据库

Meteor.publish 'roots', -> Roots.find()
Meteor.publish 'nodes', (id) ->
  # 在用户id之前加上一个“.”来获得所有该用户的章节节点
  if id.charAt(0) is '.' then Nodes.find author: id.substr(1)
  else Nodes.find root_id: id
Meteor.publish 'all_users', -> Meteor.users.find {}, {fields: {profile: 1, username: 1}}
Meteor.publish 'tags', -> Tags.find()
