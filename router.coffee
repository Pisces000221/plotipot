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
    data: -> Roots.findOne @params._id
    layoutTemplate: 'layout'
    yieldTemplates:
      'header': to: 'top'
