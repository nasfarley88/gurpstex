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

function printdiceroll(d)
-- function printdiceroll(d, tobeat)
  d = d or diceroll()
  -- tobeat = tobeat or 10
  tex.print([[\epsdice{]] .. tostring(d[1]) .. [[}]] ..
      [[\epsdice{]] .. tostring(d[2]) .. [[}]] ..
      [[\epsdice{]] .. tostring(d[3]) .. [[}]] ..
      [[\parbox[t][\baselineskip][t]{3ex}{\centering]] .. sum(d) .. [[}]] ..
      -- [[\parbox[t][\baselineskip][t]{4ex}{\centering(]] .. tostring(tobeat - sum(d)) .. [[)}]] ..
      [[\\]])
end
