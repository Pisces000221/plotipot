Meteor.subscribe 'roots'
Meteor.subscribe 'all_users'

# HTML编码函数，懒得用RegExp了……在Firefox和QupZilla下均可以工作。
# http://blog.csdn.net/cuixiping/article/details/7846806
html_encode = (s) ->
  div = document.createElement 'div'
  div.appendChild document.createTextNode s
  div.innerHTML

# 调试时，可以在控制台中使用下面命令：
# Roots.insert({title: 'xxx', author: '[user id]', visits: 12138, timestamp: 1412070002072})

Template.explore_display.helpers
  'author_name': -> Meteor.users.findOne(@author).username
  'timestamp_readable': -> (new Date @timestamp).toLocaleString()
  # Blaze你又调皮了～～～～只把< > &之类的给HTML编码一下，就是不编码换行符～～
  # 要不下次给Meteor发个PR过去？
  # https://github.com/meteor/meteor/blob/master/packages/blaze/preamble.js
  'description_encoded': -> (html_encode @description).replace /\n/g, '<br>'
  'hottest_5': -> Roots.find({}, {sort: {visits: -1}, limit: 5})
  'newest_5': -> Roots.find({}, {sort: {timestamp: -1}, limit: 5})
