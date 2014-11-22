Session.setDefault 'posting_cmt', false

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
    cmts = []
    Comments.find().forEach (c) ->
      cmts.push
        pos: c.pos
        colour: Meteor.users.findOne(c.author).profile.theme_colour ? '#ccc'
        r: Math.sqrt(c.text.length) * 3
        opacity: Math.pow(moment().diff(moment(c.timestamp), 'days', true) + 1, -0.65)
    loop_until (-> draw_comments cmts), 500

Template.leaf.helpers
  'pot_title': -> Pots.findOne(@pot_id).title
  'parents_count': -> @parents.length
  'children_count': -> @children.length
  'current_leaf': -> Leaves.findOne @toString()
  'posting_cmt': -> Session.get 'posting_cmt'

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
    .attr 'width', w - 40 # TODO: use (w - padding-left - padding-right) instead
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
  'click #btn_post_comment': -> Session.set 'posting_cmt', true
  'click #comments_canvas': (e) ->
    return if not Session.get 'posting_cmt'
    a = document.getElementById 'cmt_post_area'
    a.style.position = 'absolute'
    if e.clientX < window.innerWidth / 2 then a.style.left = e.clientX + 'px'
    else a.style.left = e.clientX - a.clientWidth + 'px'
    a.style.top = e.clientY + 'px'
    Session.set 'posting_cmt', false
