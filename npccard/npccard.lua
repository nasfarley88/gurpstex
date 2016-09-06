function diceroll()
  return {math.random(6),
          math.random(6),
          math.random(6)}
end

function sum(t)
  local sum = 0
  for k,v in pairs(t) do
    sum = sum + v
  end

  return sum
end

-- function printdiceroll(d, tobeat)
--   d = d or diceroll()
--   tobeat = tobeat or 10
--   tex.print([[\epsdice{]] .. tostring(d[1]) .. [[}]] ..
--       [[\epsdice{]] .. tostring(d[2]) .. [[}]] ..
--       [[\epsdice{]] .. tostring(d[3]) .. [[}]] ..
--       [[\parbox[t][\baselineskip][t]{3ex}{\centering]] .. sum(d) .. [[}]] ..
--       [[\parbox[t][\baselineskip][t]{4ex}{\centering(]] .. tostring(10 - sum(d)) .. [[)}]] ..
--       [[\\]])
-- end

function format_num_for_tex(num)
  if num > 9 then
    return [[\(\hspace{-0.05pt}]] .. (num - (num % 10))/10 .. [[\hspace{-0.4pt}]] .. (num % 10) .. [[\)]]
  else
    return tostring(num)
  end
end

function plainprintdiceroll(d)
  d = d or diceroll()
  tex.print([[\fail{]] .. format_num_for_tex(sum(d)) .. "}")
end

function printdiceroll(tobeat, d)
  d = d or diceroll()
  tobeat = tobeat or 10
  if tobeat < 15 then
    tocrit = 4
  elseif tobeat == 15 then
    tocrit = 5
  elseif tobeat > 15 then
    tocrit = 6
  end

  if sum(d) >= tobeat + 10 or sum(d) > 16 then
    tex.print([[\critfail{]] .. format_num_for_tex(sum(d)) .. "}")
  elseif sum(d) > tobeat then
    tex.print([[\fail{]] .. format_num_for_tex(sum(d)) .. "}")
  elseif sum(d) <= tocrit then
    tex.print([[\critpass{]] .. format_num_for_tex(sum(d)) .. "}")
  else
    tex.print([[\pass{]] .. format_num_for_tex(sum(d)) .. "}")
  end
end

function hpstack(hp)
  tex.print([[\begin{tabular}{@{}c@{ }c@{}}]])
  tex.print([[\(+\)ve & \(-\)ve\\]])
  for i=hp,1,-1 do tex.print([[\(]] .. i .. [[\) & \(]] .. i-(hp+1) .. [[\)\\]]) end
  tex.print([[\(0\) & \\]])
  -- for i=-1,-1*hp,-1 do tex.print([[\(]] .. i .. [[\)\break]]) end
  tex.print([[\end{tabular}]])
end

function lines_from(file)
  -- if not file_exists(file) then return {} end
  lines = {}
  for line in io.lines(file) do 
    lines[#lines + 1] = line
  end
  return lines
end

function random_choice(t)
  return t[math.random(#t)]
end

function print_random_quote()
  tex.print(random_choice(lines_from("shakespeare_quotes.txt")))
end


function print_random(min, max)
  min = min or 8
  max = max or 13
  -- Could be useful. From http://www.design.caltech.edu/erik/Misc/Gaussian.html
  -- y1 = sqrt( - 2 ln(x1) ) cos( 2 pi x2 )
  -- y2 = sqrt( - 2 ln(x1) ) sin( 2 pi x2 )
  
  y1 = 0/0
  y2 = -0/0
  -- Strange test fr nan, check if the number is equal to itself
  -- while y1 ~= y1 or y2 ~= y2 do
    x1 = math.random()
    x2 = math.random()
    y1 = -2*math.log(x1)*math.cos(2*math.pi*x2)
    if y1 < 0 then
      y1 = -math.sqrt(-y1)
    else
      y1 = math.sqrt(y1)
    end
    stat = math.floor(2*y1+10)
    if stat < min or stat > max then
      print_random(min, max)
      return
    end
  tex.print(math.floor(2*y1+10))
end


function print_pass()
  tex.print([[\pass{10}]])
end
