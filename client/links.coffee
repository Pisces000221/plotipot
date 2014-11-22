Template.leaf_link.helpers
  'pot_title': -> Pots.findOne(@data.pot_id).title
