Template.tag_page.helpers
  'current_root': -> Roots.findOne this.toString()
  'roots_count': -> @roots.length
