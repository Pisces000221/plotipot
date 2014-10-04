Template.chapter_link.helpers
  'my_theme_colour': -> Meteor.users.findOne(@data.author).profile.theme_colour
  'root_title': -> Roots.findOne(@data.root_id).title
