Session.setDefault 'cur_pot_id', ''

Template.pot_details_summary.helpers
  'my_leaves_count': ->
    Session.set 'cur_pot_id', @_id
    Leaves.find().count()

Template.pot_details.helpers
  'cur_pot_id': -> Session.get 'cur_pot_id'

  'inc_visits': ->
    if @_id and not Session.get('counted_pot_' + Session.get 'cur_pot_id')
      Meteor.call 'hit_pot', @_id
      Session.set ('counted_pot_' + Session.get 'cur_pot_id'), true
    ''

Template.pot_details.events
  'click #btn_create_leaf': -> Router.go '/create_leaf/' + @_id + '/0'

Template.pot_details.rendered = ->
  @autorun ->
    # That's my boy, Meteor! 终于来了一件令人爽透的事情了！
    # Meteor可以自动判断哪些是需要的数据，不会在访问次数变化的时候乱更新
    c = Leaves.find {}, fields: {_id: 1, children: 1, parents: 1, author: 1, title: 1}
    links = []
    display = []
    # http://stackoverflow.com/q/12956438
    # http://docs.meteor.com/#foreach
    c.forEach (leaf) ->
      links.push { source: leaf._id, target: child } for child in leaf.children
      links.push { source: leaf._id, target: leaf._id } if leaf.parents.length is 0 and leaf.children.length is 0
      display[leaf._id] =
        title: leaf.title
        colour: Meteor.users.findOne(leaf.author).profile.theme_colour ? '#ccc'
    # 必须要把Session.get放在外面，否则Meteor不会帮我们实时更新
    display['pot_id'] = Session.get 'cur_pot_id'
    draw_graph links, display

# 根据提供的信息画出树形图
# 来自http://bl.ocks.org/d3noob/5141278
draw_graph = (links, display) ->
  nodes = {}
  # Compute the distinct nodes from the links.
  links.forEach (link) ->
    link.source = nodes[link.source] || (nodes[link.source] = name: link.source)
    link.target = nodes[link.target] || (nodes[link.target] = name: link.target)

  width = window.innerWidth - 20
  height = 500

  # add the curvy lines
  tick = ->
    path.attr 'd', (d) ->
      dx = d.target.x - d.source.x
      dy = d.target.y - d.source.y
      dr = Math.sqrt(dx * dx + dy * dy)
      "M#{d.source.x},#{d.source.y}A#{dr},#{dr} 0 0,1 #{d.target.x},#{d.target.y}"
    node.attr 'transform', (d) -> "translate(#{d.x},#{d.y})"

  force = d3.layout.force()
    .nodes d3.values(nodes)
    .links links
    .size [width, height]
    .linkDistance 90
    .charge -300
    .on 'tick', tick
    .start();

  # http://stackoverflow.com/q/10784018/#comment35867940_10911546
  d3.select('#d3_canvas').selectAll('*').remove()
  svg = d3.select '#d3_canvas'
    .attr 'width', width
    .attr 'height', height

  # build the arrow.
  svg.append('svg:defs').selectAll 'marker'
      .data ['end']       # Different link/path types can be defined here
    .enter().append 'svg:marker'     # This section adds in the arrows
      .attr 'id', String
      .attr 'viewBox', '0 -5 10 10'
      .attr 'refX', 29
      .attr 'refY', -3
      .attr 'markerWidth', 6
      .attr 'markerHeight', 6
      .attr 'orient', 'auto'
    .append 'svg:path'
      .attr 'd', 'M0,-5L9,0L0,5'

  # add the links and the arrows
  path = svg.append('svg:g').selectAll 'path'
      .data force.links()
    .enter().append 'svg:path'
      .attr 'class', 'link'
      .attr 'marker-end', 'url(#end)'

  # define the nodes
  node = svg.selectAll '.node'
      .data force.nodes()
    .enter().append 'g'
      .attr 'class', 'node'
      .call force.drag
      .on 'dblclick', (d) -> Router.go "/leaf/#{display['pot_id']}/#{d.name}"

  # add the nodes
  node.append 'circle'
      .attr 'r', 18
      .attr 'fill', (d) -> display[d.name].colour
      .attr 'fill-opacity', 0.3

  # add the text 
  node.append 'text'
      .attr 'x', 18
      .attr 'dy', '.35em'
      .attr 'fill', (d) -> display[d.name].colour
      .text (d) -> display[d.name].title

######## 创建新节点的部分 ########
window.editor = undefined

Template.create_leaf.rendered = ->
  window.editor = new Editor()
  window.editor.render()

# 下面的方法会导致数据失去互动性(reactivity)
#parent_id = -> if @parent_id? then @parent_id else @parent_id = Session.get 'forking_parent'
Template.create_leaf.helpers
  'forking_parent_leaf': -> Session.get('forking_parent') isnt '0'
  'parent_leaf_author': -> Meteor.users.findOne Leaves.findOne(Session.get 'forking_parent').author
  'parent_leaf_title': -> Leaves.findOne(Session.get 'forking_parent').title

Template.create_leaf.events
  'click #btn_newleaf_submit': ->
    Meteor.call 'create_leaf',
      pot_id: @_id
      title: document.getElementById('title').value
      contents: window.editor.codemirror.getValue()
    , (err, result) ->
      # result是新创建的节点的id
      if err? then alert err.toString(); return
      parent_id = Session.get 'forking_parent'
      Meteor.call 'link_leaves', parent_id, result if parent_id isnt '0'
    Router.go '/pot_details/' + @_id

Template.merge_leaf.helpers
  'child_leaf_author': -> Meteor.users.findOne(Leaves.findOne(Session.get 'merging_child').author)
  'child_leaf_title': -> Leaves.findOne(Session.get 'merging_child').title
  'leaves_by_me': -> Leaves.find author: Meteor.userId()

Template.merge_leaf.events
  'click .a-leaf': (e) ->
    Meteor.call 'link_leaves', e.currentTarget.attributes['data-target-id'].value, Session.get 'merging_child'
    Router.go '/pot_details/' + @pot_id
