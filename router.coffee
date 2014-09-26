# Configure iron:router
Router.map ->
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
