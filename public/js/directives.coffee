directives = angular.module 'myApp.directives', []

directives.directive 'logoDraggable', [() ->
  (scope, elm, attrs) ->
    elm.draggable 
      containment: '#container'
      cursor: 'move'
      revert: (event, ui) ->
        dropped = $(this)
        if not event 
          dropped.removeClass 'emmaLogo wisdomLogo alertLogo usherLogo'
          logoId = Number dropped.attr 'idx'
          rel = scope.rel
          rel[i] = -1 for id, i in rel when id is logoId
          scope.$apply()
        dropped.data("draggable").originalPosition = 
          top: 0
          left: 0
        not event;
]

directives.directive 'logoDroppable', [() ->
  (scope, elm, attrs) ->
    elm.droppable 
      drop: (event, ui) ->
        droppedTo = $(this)
        dropped = ui.draggable

        className =  droppedTo.text() + 'Logo'
        oldDropped = $('.'+className) 
        if oldDropped.length is 1
          oldDropped.animate oldDropped.data('draggable').originalPosition, 'slow'
          oldDropped.removeClass className

        dropped.position 
          of: droppedTo
          my: 'left top'
          at: 'left top'
        dropped.removeClass 'emmaLogo wisdomLogo alertLogo usherLogo'
        dropped.addClass className

        logoId = Number dropped.attr 'idx'
        slotId = Number droppedTo.attr 'idx'
        rel = scope.rel
        rel[i] = -1 for id, i in rel when id is logoId
        rel[slotId] = logoId
        scope.$apply()

]

directives.directive 'robotDraggable', [() ->
  (scope, elm, attrs) ->
    elm.draggable 
      containment: '#container'
      cursor: 'move'
      revert: true
]

directives.directive 'robotDroppable', [() ->
  (scope, elm, attrs) ->
    robotMoveCb = (newState) ->
      oldState = scope.state

      for v, i in newState
        if v isnt oldState[i]
          robotMove = {'idx':i, 'v': v}
          break

      if robotMove? #why received multiple times?
        dropped = $('.numPile span').filter () ->
          Number($(this).text()) is robotMove.v
        droppedTo = $('span[idx="'+robotMove.idx+'"]')
        dropped.position 
          of: droppedTo
          my: 'left top'
          at: 'left top' 

        droppedTo.droppable 'disable'
        dropped.draggable 'disable'
        dropped.draggable 'option', 'revert', false
        dropped.addClass 'badge-important'

        scope.state = newState


    elm.droppable 
      drop: (event, ui) ->
        droppedTo = $(this)
        dropped = ui.draggable

        dropped.position 
          of: droppedTo
          my: 'left top'
          at: 'left top'

        droppedTo.droppable 'disable'
        dropped.draggable 'disable'
        dropped.draggable 'option', 'revert', false
        dropped.addClass 'badge-success'

        idx = Number $(this).attr('idx')
        v = Number dropped.text()

        #user move
        scope.state[idx] = v
        scope.moves.push 
          idx: idx
          v: v
        #robot move
        state = (v for v in scope.state)
        robotMove state, robotMoveCb

        scope.$apply()
]

#robot logic
parse = (S) ->
  isArray = (value) ->
    {}.toString.call(value) is '[object Array]'
  if S and isArray(S) and S.length == 10
    N = (0 for i in [0..9])
    M = 0
    MIN = 1
    MAX = 9
    for v, i in S
      if v < 0 or (v > 0 and N[v] > 0)
        null
      else if v > 0 and v < 10
        N[v] = 1
        M |= (1<<i)
    
    for id in [1..9]
      if N[id] is 0 
        MIN = id
        break
    for id in [9..1]
      if N[id] is 0
        MAX = id
        break

    'M': M
    'MAX': MAX
    'MIN': MIN
  else null

putA = (S, M, v) ->
  if not (M&4) then S[2] = v else S[8] = v
putB = (S, M, v) ->
  if not (M&16) then S[4] = v else S[6] = v
putC = (S, M, v) ->
  if not (M&2) then S[1] = v
  else if not (M&8) then S[3] = v
  else if not (M&32) then S[5] = v
  else if not (M&128) then S[7] = v
  else S[9] = v 

robotMove = (S, uiCb) ->
  #calculate robot's next move
  A = [2, 8]
  B = [4, 6]
  C = [1, 3, 5, 7, 9]

  P = parse S

  if P? and P.M isnt (1<<10) - 2
    M = P.M 
    MAX = P.MAX
    MIN = P.MIN
    if not (M&260)
      if (M&80) isnt 80 then putB S, M, MAX
      else 
        if (MAX+MIN <= S[4]+S[6]) then putA S, M, MIN
        else if (M&682) isnt 682 then putC S, M, MAX
        else putA S, M, MIN
    else if (M&260) is 260
      if not (M&80) 
        if MAX+MIN>= S[2]+S[8] then putB S, M, MAX
        else if (M&682) isnt 682 then putC S, M, MIN
        else putB S, M, MAX
      else if (M&80) isnt 80 then putB S, M, MAX
      else putC S, M, MIN
    else 
      putA S, M, MIN
    uiCb and uiCb S