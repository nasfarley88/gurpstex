function box_width()
  return tex.skip['boxwidth'].width
end


function bounding_box()
  return [[\draw[draw=none, use as bounding box] (-]]
    .. box_width()/2 ..
    [[sp,-]]
    .. box_width()/2 ..
    [[sp) rectangle (]] 
    .. box_width()/2 ..
    [[sp, ]]
    .. box_width()/2 ..
    [[sp);]]
end

function tikz_coord(x, y)
  return [[(]] .. x .. [[sp,]] .. y .. [[sp)]]
end

function number_box(x, center_x, center_y, name)
  center_x = center_x or 0
  center_y = center_y or 0
  if name then
    name = "(" .. name .. ")"
  else
    name = ""
  end
  -- return [[\draw[draw=none] ]] .. name .. [[(-]]
  --   .. box_width()/2-center_x ..
  --   [[sp,-]]
  --   .. box_width()/2-center_y ..
  --   [[sp) rectangle (]]
  --   .. box_width()/2+center_x ..
  --   [[sp, ]]
  --   .. box_width()/2+center_y ..
  --   [[sp);
  return [[
    \node[draw, rectangle, inner sep=]] .. box_width()/2 .. [[sp] ]] .. name .. [[ {};
      \node[anchor=center] (]] ..
  [[) at ]] .. tikz_coord(center_x, center_y) .. [[ {]] .. x .. [[};]]
end

function bang_box(x, center_x, center_y)
  center_x = center_x or 0
  center_y = center_y or 0
  return [[
    \node[draw, fill=white, starburst, starburst point height=4pt, random starburst=]] 
    .. math.random(500) .. [[, inner sep=4pt, anchor=center] at ]] 
    .. tikz_coord(center_x, center_y) .. [[ {};
      \node[anchor=center] at ]] .. tikz_coord(center_x, center_y) .. [[ {\tiny ]] .. x .. [[};
      ]]
end

function reload_box(center_x, center_y, name)
  if name then
    name = "(".. name .. ")"
  else
    name = ""
  end

  return [[\draw[draw=none] ]] ..
    tikz_coord(center_x-box_width()/2, center_y-box_width()/2) ..
    [[ rectangle ]] ..
    tikz_coord(center_x+box_width()/2, center_y+box_width()/2) ..
    [[;]] ..
    [[\node[draw, anchor=center, inner sep=1pt, circle] ]] .. name ..
    [[ at ]] .. tikz_coord(center_x-box_width()/4, center_y) .. [[ {\tiny \(R\)};]]
end

function interbox_space()
  return [[\hspace{-0.0pt}]]
end

function tikz(x)
  return [[\tikz{]] .. x .. [[}]]
end

function row_of_boxes(n, reload_n)
  reload_n = reload_n or 1
  for i=n,1,-1 do
    tex.sprint(tikz(bounding_box() .. number_box(i)) .. interbox_space())
  end
  if reload_n > 1 then
    for i=1,reload_n do
      tex.print(tikz(bounding_box() .. bang_box([[\(R_]] .. i .. [[\)]])))
    end
  else
    tex.print(tikz(bounding_box() .. bang_box("$R$")))
  end
end

function column_of_bullets(n, reload_n)
-- function column_of_bullets(n)
  tex.sprint([[\begin{minipage}[t]{2\boxwidth}]])
  tex.sprint([[\vspace{0pt}]])
  tex.sprint([[\begin{tikzpicture}]])
  for i=0,n do
    number_box_name = "numberbox" .. i
    tex.sprint(number_box(i, 0, i*box_width(), number_box_name))

    -- Reload boxes
    if reload_n == n and i ~= 0 then
      reload_box_name = "reload" .. i
      tex.sprint(reload_box(-box_width(), i*box_width(), reload_box_name))
      tex.sprint([[\path[->] ]] ..
          "(" .. reload_box_name .. ")" ..
          [[ edge ]] ..
          "(" .. number_box_name .. ")" .. [[;]])
    else
      -- throw an error somehow TODO
    end
  end

  if reload_n == 1 then
    tex.sprint(reload_box(-box_width(), 1*box_width()))
    for i=2,n do
      reload_box_name = "reload" .. 1
      number_box_name = "numberbox" .. i
      tex.sprint([[\draw[->] ]] ..
          "(" .. reload_box_name .. ")" ..
          [[ to[to path={(\tikztostart) |- (\tikztotarget)}] ]] ..
          "(" .. number_box_name .. ")" .. [[;]])
    end
  end

  tex.sprint([[\end{tikzpicture}]])
  tex.sprint([[\end{minipage}]])
end

function column_of_reloads(n)
  tex.sprint([[\begin{minipage}[t]{\boxwidth}]])
  tex.sprint([[\vspace{0pt}]])
  tex.sprint([[\begin{tikzpicture}]])
  for i=1,n do
    -- tex.sprint(bang_box([[\(R_{]] .. i .. [[}\)]], 0, i*box_width()))
    tex.sprint(reload_box(0, i*box_width()))
  end
  tex.sprint([[\end{tikzpicture}]])
  tex.sprint([[\end{minipage}]])
end

function single_reload(n)
  tex.sprint([[\begin{minipage}[t]{\boxwidth}]])
  tex.sprint([[\vspace{0pt}]])
  tex.sprint([[\begin{tikzpicture}]])
  -- Draw a big fat ol' arrow to the top
  -- bounding box so the arrow points 'out' of the picture
  tex.sprint([[\draw[draw=none, use as bounding box] ]] 
      .. tikz_coord(-box_width()/2, -box_width()/2) ..
      [[ rectangle ]]
      .. tikz_coord(box_width()/2, (n+0.5)*box_width()) ..
      [[;]]
  )
  tex.sprint([[\node (thebottom) at ]] .. tikz_coord(0, box_width()+box_width()*0.5) .. [[ {};]])
  tex.sprint([[\node (thetop) at ]] .. tikz_coord(box_width(), n*box_width()) .. [[ {};]])
  tex.sprint([[\path[draw, -latex] (thebottom) |- (thetop);]])
  tex.sprint(bang_box([[\(R\)]], 0, box_width()))
  tex.sprint([[\end{tikzpicture}]])
  tex.sprint([[\end{minipage}]])
end
