# Configure iron:router
Router.map ->
  # 一般页面（没有id作为参数）
  @route 'home_page',
    path: '/'
    layoutTemplate: 'layout'
    yieldTemplates:
      'header': to: 'top'
  @route 'register_page',
    path: '/register'
    layoutTemplate: 'layout'
    yieldTemplates:
      'header': to: 'top'
  @route 'login_page',
    path: '/login'
    layoutTemplate: 'layout'
    yieldTemplates:
      'header': to: 'top'
  @route 'explore',
    layoutTemplate: 'layout'
    yieldTemplates:
      'header': to: 'top'
  @route 'new_root',
    layoutTemplate: 'layout'
    yieldTemplates:
      'header': to: 'top'
  # 传入id的页面
  @route 'root_details',
    path: '/root_details/:_id'
    data: ->
      Meteor.subscribe 'nodes', @params._id
      Roots.findOne @params._id
    layoutTemplate: 'layout'
    yieldTemplates:
      'header': to: 'top'
  @route 'create_node',
    path: '/create_node/:_id'
    data: ->
      Meteor.subscribe 'nodes', @params._id
      Roots.findOne @params._id
    layoutTemplate: 'layout'
    yieldTemplates:
      'header': to: 'top'
  @route 'chapter',
    path: '/chapter/:root_id/:_id'
    data: ->
      # 拉出和它一起的所有章节……
      Meteor.subscribe 'nodes', @params.root_id
      # 丢给页面玩去
      Nodes.findOne @params._id
    layoutTemplate: 'layout'
    yieldTemplates:
      'header': to: 'top'
