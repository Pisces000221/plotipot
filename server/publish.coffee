# 在这里向客户端发布所有的数据库

Meteor.publish 'pots', -> Pots.find()
Meteor.publish 'leaves', (id) ->
  # 在用户id之前加上一个“.”来获得所有该用户的章节节点
  if id.charAt(0) is '.' then Leaves.find author: id.substr(1)
  else Leaves.find pot_id: id
Meteor.publish 'all_users', -> Meteor.users.find {}, {fields: {profile: 1, username: 1}}
Meteor.publish 'tags', -> Tags.find()
Meteor.publish 'comments', (leaf_id) ->
  s = Leaves.findOne(leaf_id).comments
  Comments.find _id: { $in: s }
