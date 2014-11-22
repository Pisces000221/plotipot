# Configure iron:router
if Meteor.isClient then Session.setDefault 'forking_parent', '0'

Router.map ->
  # 一般页面（没有id作为参数）
  @route 'home_page',
    path: '/'
    layoutTemplate: 'layout'
    yieldTemplates: 'header': to: 'top'
  @route 'register_page',
    path: '/register'
    layoutTemplate: 'layout'
    yieldTemplates: 'header': to: 'top'
  @route 'login_page',
    path: '/login'
    layoutTemplate: 'layout'
    yieldTemplates: 'header': to: 'top'
  @route 'explore',
    layoutTemplate: 'layout'
    yieldTemplates: 'header': to: 'top'
  @route 'tags',
    layoutTemplate: 'layout'
    yieldTemplates: 'header': to: 'top'
  @route 'help_page',
    path: '/help'
    layoutTemplate: 'layout'
    yieldTemplates: 'header': to: 'top'
  @route 'new_pot',
    layoutTemplate: 'layout'
    yieldTemplates: 'header': to: 'top'
  # 传入id的页面
  @route 'user_page',
    path: '/user_page/:_id'
    data: -> Meteor.users.findOne @params._id
    layoutTemplate: 'layout'
    yieldTemplates: 'header': to: 'top'
  @route 'tag_page',
    path: '/tag/:name'
    data: -> Tags.findOne name: @params.name
    layoutTemplate: 'layout'
    yieldTemplates: 'header': to: 'top'
  @route 'pot_details',
    path: '/pot_details/:_id'
    data: ->
      Meteor.subscribe 'leaves', @params._id
      Pots.findOne @params._id
    layoutTemplate: 'layout'
    yieldTemplates: 'header': to: 'top'
  @route 'create_leaf',
    path: '/create_leaf/:pot_id/:leaf_id'
    data: ->
      Meteor.subscribe 'leaves', @params.pot_id
      # 目前只能把数据存储在Session里吗？？
      # 不能放在返回值里，否则会失去同步性（谁知道Meteor又干了什么坑爹的事情！）
      if Meteor.isClient then Session.set 'forking_parent', @params.leaf_id
      Pots.findOne @params.pot_id
    layoutTemplate: 'layout'
    yieldTemplates: 'header': to: 'top'
  @route 'merge_leaf',
    path: '/merge_leaf/:pot_id/:leaf_id'
    data: ->
      Meteor.subscribe 'leaves', @params.pot_id
      if Meteor.isClient then Session.set 'merging_child', @params.leaf_id
      Pots.findOne @params.pot_id
    layoutTemplate: 'layout'
    yieldTemplates: 'header': to: 'top'
  @route 'leaf',
    path: '/leaf/:pot_id/:_id'
    data: ->
      # 拉出和它一起的所有章节……
      Meteor.subscribe 'leaves', @params.pot_id
      # 还有评论……
      Meteor.subscribe 'comments', @params._id
      # 丢给页面玩去
      Leaves.findOne @params._id
    layoutTemplate: 'layout'
    yieldTemplates: 'header': to: 'top'
