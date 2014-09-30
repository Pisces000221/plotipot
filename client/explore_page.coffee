Meteor.subscribe 'roots'

# 调试时，可以在控制台中使用下面命令：
# Roots.insert({title: 'xxx', author: '[user id]', visits: 12138, timestamp: 1412070002072})

Template.explore_display.helpers
  'hottest_5': -> Roots.find({}, {sort: {visits: -1}, limit: 5})
  'newest_5': -> Roots.find({}, {sort: {timestamp: -1}, limit: 5})
  'timestamp_readable': -> (new Date @timestamp).toLocaleString()
