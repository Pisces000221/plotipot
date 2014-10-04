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
  @route 'new_root',
    layoutTemplate: 'layout'
    yieldTemplates: 'header': to: 'top'
  # 传入id的页面
  @route 'root_details',
    path: '/root_details/:_id'
    data: ->
      Meteor.subscribe 'nodes', @params._id
      Roots.findOne @params._id
    layoutTemplate: 'layout'
    yieldTemplates: 'header': to: 'top'
  @route 'create_node',
    path: '/create_node/:root_id/:node_id'
    data: ->
      Meteor.subscribe 'nodes', @params.root_id
      # 目前只能把数据存储在Session里吗？？
      # 不能放在返回值里，否则会失去同步性（谁知道Meteor又干了什么坑爹的事情！）
      if Meteor.isClient then Session.set 'forking_parent', @params.node_id
      Roots.findOne @params.root_id
    layoutTemplate: 'layout'
    yieldTemplates: 'header': to: 'top'
  @route 'merge_node',
    path: '/merge_node/:root_id/:node_id'
    data: ->
      Meteor.subscribe 'nodes', @params.root_id
      if Meteor.isClient then Session.set 'merging_child', @params.node_id
      Roots.findOne @params.root_id
    layoutTemplate: 'layout'
    yieldTemplates: 'header': to: 'top'
  @route 'chapter',
    path: '/chapter/:root_id/:_id'
    data: ->
      # 拉出和它一起的所有章节……
      Meteor.subscribe 'nodes', @params.root_id
      # 丢给页面玩去
      Nodes.findOne @params._id
    layoutTemplate: 'layout'
    yieldTemplates: 'header': to: 'top'
