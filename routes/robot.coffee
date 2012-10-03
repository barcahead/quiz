isArray = (value) ->
  {}.toString.call(value) is '[object Array]'

parse = (S) ->
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

robotMove = (S) ->
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

exports.checkMoves =  (u) ->
  moves = u.moves
  finalState = u.state

  state = (0 for v in [0..9])

  if not moves or not finalState or not isArray(moves) or moves.length isnt 5 or not isArray(finalState) or finalState.length isnt 10
    return false 
  for move in moves
    idx = move.idx
    v = move.v
    if idx < 0 or idx > 9 or state[idx] isnt 0
      return false 
    else 
      state[idx] = v
      robotMove state
  for v, i in state
    if v isnt finalState[i]
      return false
  if state[2] + state[8] > state[4] + state[6]
    return true
  return false
