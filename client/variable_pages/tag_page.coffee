Template.tag_page.helpers
  'current_pot': -> Pots.findOne this.toString()
  'pots_count': -> @pots.length
