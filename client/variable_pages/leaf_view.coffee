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

displayed_comments = []

Template.leaf.rendered = ->
  displayed_comments = []
  @autorun ->
    cmts = []
    Comments.find().forEach (c) -> if displayed_comments.indexOf(c._id) is -1
      displayed_comments.push c._id
      cmts.push
        pos: c.pos
        colour: Meteor.users.findOne(c.author).profile.theme_colour ? '#ccc'
        r: Math.sqrt(c.text.length) * 3
        opacity: Math.pow(moment().diff(moment(c.timestamp), 'days', true) + 1, -0.65)
        text: c.text
    loop_until (-> draw_comments cmts), 500

Template.leaf.helpers
  'pot_title': -> Pots.findOne(@pot_id).title
  'parents_count': -> @parents.length
  'children_count': -> @children.length
  'current_leaf': -> Leaves.findOne @toString()
  'liked': -> Leaves.findOne(@_id).liked_by.indexOf(Meteor.userId()) isnt -1
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
  content_container = document.getElementById 'contents'
  # TODO: use (w - padding-left - padding-right) instead
  w = content_container.clientWidth - 40
  h = content_container.clientHeight
  if h is 0 then return false
  svg = d3.select '#comments_canvas'
    .attr 'width', w
    .attr 'height', h
  for cmt in cmts
    cir = svg.append 'circle'
      .attr 'r', 0
      .style 'opacity', cmt.opacity
      .attr 'cx', cmt.pos.x * w
      .attr 'cy', cmt.pos.y * h
      .attr 'fill', cmt.colour
      # http://stackoverflow.com/q/20635986
      # http://stackoverflow.com/q/11336251
      .on 'mouseover', ->
        d3.select('#cmt_tip').transition().duration(300)
          .style 'opacity', 1
          .style 'visibility', 'visible'
        document.getElementById('cmt_tip_text').innerHTML = @tt
        # 更新文字位置
        c = document.getElementById 'contents'
        t = d3.select this
        cx = parseInt(t.attr 'cx')
        cy = parseInt(t.attr 'cy')
        r = parseInt(t.attr 'r')
        tip = document.getElementById('cmt_tip')
        if cx < window.innerWidth / 2 then tip.style.left = cx + 'px'
        else tip.style.left = cx - tip.clientWidth + 'px'
        tip.style.top = cy + c.offsetTop + r + 'px'
        # 变色龙出动！！
        rgbs = window.hex_to_rgb @colour
        tip.style.backgroundColor = "rgba(#{rgbs.r}, #{rgbs.g}, #{rgbs.b}, 0.7)"
        tip.style.color = if 0.213 * rgbs.r + 0.715 * rgbs.g + 0.072 * rgbs.b >= 0.5 then 'black' else 'white'
      .on 'mouseleave', ->
        d3.select('#cmt_tip').transition().duration(200).style 'opacity', 0
        setTimeout (-> document.getElementById('cmt_tip').style.visibility = 'hidden'), 200
      # 动画
      .transition().delay(Math.random() * 500)
      .transition().duration(250).ease('quad-out').attr 'r', cmt.r
    cir[0][0].tt = cmt.text
    cir[0][0].colour = cmt.colour

Template.leaf.events
  'click button': -> window.go_login() if not Meteor.userId()?
  'click #btn_like': -> Meteor.call 'toggle_like_leaf', @_id if Meteor.userId()?
  'click #btn_fork': -> Router.go "/create_leaf/#{@pot_id}/#{@_id}" if Meteor.userId()?
  'click #btn_merge': -> Router.go "/merge_leaf/#{@pot_id}/#{@_id}" if Meteor.userId()?
  'click #btn_start_post_comment': -> Session.set 'posting_cmt', not Session.get('posting_cmt')
  'click #comments_canvas': (e) ->
    return if not Session.get 'posting_cmt'
    a = document.getElementById 'cmt_post_area'
    c = document.getElementById 'contents'
    cc = document.getElementById 'comments_canvas'
    a.style.visibility = 'visible'
    a.style.position = 'absolute'
    if e.clientX < window.innerWidth / 2 then a.style.left = e.clientX + 'px'
    else a.style.left = e.clientX - a.clientWidth + 'px'
    # TODO: use c.padding-left instead of 20
    @selected_pos = x: (e.clientX - 20) / cc.width.baseVal.value, y: (e.clientY - c.offsetTop + window.scrollY) / cc.height.baseVal.value
    console.log @selected_pos
    a.style.top = e.clientY + window.scrollY + 'px'
  'click #btn_post_comment': ->
    return if not Session.get 'posting_cmt'
    Meteor.call 'post_comment', { leaf_id: @_id, text: document.getElementById('txt_comment').value, pos: @selected_pos }
    document.getElementById('txt_comment').value = ''
    Meteor.subscribe 'comments', @_id
    document.getElementById('cmt_post_area').style.visibility = 'hidden'
    Session.set 'posting_cmt', false
