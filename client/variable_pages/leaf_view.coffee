# 可以在Web Console中使用以下命令调试：
#   loop_until(function () { a++; console.log(a); return a >= 10; }, 500)
#   a = 0
# 应该每0.5秒输出一个数字，每次增加1，到10时停止
loop_until = (func, intv) ->
  timer = setInterval ->
    clearInterval timer if func()
  ,intv
  return

Template.leaf.rendered = ->
  @autorun ->
    cmts = [
      pos: { x: 0.3, y: 0.3 }, colour: '#F0F0F0', r: 10, opacity: 0.6
      pos: { x: 0.5, y: 0.3 }, colour: '#C0C0FF', r: 20, opacity: 0.4
    ]
    loop_until (-> draw_comments cmts), 500

Template.leaf.helpers
  'pot_title': -> Pots.findOne(@pot_id).title
  'parents_count': -> @parents.length
  'children_count': -> @children.length
  'current_leaf': -> Leaves.findOne @toString()

  'rendered_contents': -> marked @contents

  'inc_visits': ->
    if @_id and not Session.get('counted_leaf_' + @_id)
      Meteor.call 'hit_leaf', @_id
      Session.set ('counted_leaf_' + @_id), true
    ''

draw_comments = (cmts) ->
  # http://stackoverflow.com/questions/15615552
  # http://bl.ocks.org/mbostock/1087001
  d3.select('#comments_canvas').selectAll('*').remove()
  content_container = document.getElementById 'contents'
  w = content_container.clientWidth
  h = content_container.clientHeight
  if h is 0 then return false
  svg = d3.select '#comments_canvas'
    .attr 'width', w
    .attr 'height', h
  for cmt in cmts
    svg.append 'circle'
      .attr 'r', cmt.r
      .style 'opacity', cmt.opacity
      .attr 'transform', "translate(#{cmt.pos.x * w},#{cmt.pos.y * h})"
      .attr 'fill', cmt.colour

Template.leaf.events
  'click #btn_fork': -> Router.go "/create_leaf/#{@pot_id}/#{@_id}"
  'click #btn_merge': -> Router.go "/merge_leaf/#{@pot_id}/#{@_id}"
