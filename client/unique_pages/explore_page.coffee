Meteor.subscribe 'pots'
Meteor.subscribe 'all_users'

# 调试时，可以在控制台中使用下面命令：
# Pots.insert({title: 'xxx', author: '[user id]', visits: 12138, timestamp: 1412070002072})

Template.explore_display.helpers
  'hottest_5': -> Pots.find({}, {sort: {visits: -1}, limit: 5})
  'newest_5': -> Pots.find({}, {sort: {timestamp: -1}, limit: 5})
