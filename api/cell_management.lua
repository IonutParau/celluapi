pushabilitySheet = {}
moddedMovers = {}
moddedBombs = {}
moddedTrash = {}
cellsForIDManagement = {}
cellLabels = {}
cellWeights = {}

function broadcastSignals(sender, signal)
  for name, mod in modcache do
    if name ~= sender then
      if mod.onModSignalRecieved then
        mod.onModSignalRecieved(sender, signal)
      end
    end
  end
end

function sendSignal(sender, reciever, signal)
  local rmod = modcache[reciever]

  if rmod.onModSignalRecieved then
    rmod.onModSignalRecieved(sender, signal)
  end
end

function calculateCellPosition(x, y)
  return {
    x = math.floor((x - zoom/2 + offx)/zoom),
    y = math.floor((y - zoom/2 + offx)/zoom)
  }
end

function setCell(x, y, id, rot, lastvars)
  local original = CopyCell(x, y)
  rot = rot or original.rot
  lastvars = lastvars or original.lastvars

  cells[y][x].ctype = id
  cells[y][x].rot = rot
  cells[y][x].lastvars = lastvars
  for _, mod in pairs(modcache) do
    if mod.onModSetCell ~= nil then
      mod.onModSetCell(id, x, y, rot, lastvars, original)
    end
  end
end

function calculateScreenPosition(x, y)
  return {
    x = math.floor(x*zoom-offx+zoom/2),
    y = math.floor(y*zoom-offy+zoom/2)
  }
end

function walkDivergedPath(from_x, from_y, to_x, to_y, depth)
  local dx, dy = from_x - to_x, from_y - to_y

  local dir = 0
  depth = depth or 0

  if dx == -1 then dir = 0 elseif dx == 1 then dir = 2 end
  if dy == -1 then dir = 1 elseif dy == 1 then dir = 3 end 

  local checkedrot = cells[to_y][to_x].rot

  if depth > 999999 then
    cells[to_y][to_x].ctype = 11
  end

  if cells[to_y][to_x].ctype == 15 then
    if (checkedrot-1)%4 == dir then
      dir = (dir+1)%4
    elseif (checkedrot+2)%4 == dir then
      dir = (dir-1)%4
    else
      return {
        x = to_x,
        y = to_y
      }
    end

    dx, dy = 0, 0

    if dir == 0 then dx = 1 elseif dir == 2 then dx = -1 end
    if dir == 1 then dy = 1 elseif dir == 3 then dy = -1 end

    return walkDivergedPath(to_x, to_y, to_x + dx, to_y + dy, depth + 1)
  elseif cells[to_y][to_x].ctype == 30 then
    if (checkedrot+1)%2 == dir%2 then
      dir = (dir+1)%4
    else
      dir = (dir-1)%4
    end

    dx, dy = 0, 0

    if dir == 0 then dx = 1 elseif dir == 2 then dx = -1 end
    if dir == 1 then dy = 1 elseif dir == 3 then dy = -1 end

    return walkDivergedPath(to_x, to_y, to_x + dx, to_y + dy, depth + 1)
  elseif cells[to_y][to_x].ctype == 37 then
    if checkedrot%2 == dir%2 then
      return walkDivergedPath(to_x, to_y, to_x - dx, to_y - dy, depth + 1)
    else
      return {
        x = to_x,
        y = to_y
      }
    end
  elseif cells[to_y][to_x].ctype == 38 then
    return walkDivergedPath(to_x, to_y, to_x - dx, to_y - dy, depth + 1)
  else
    return {
      x = to_x,
      y = to_y
    }
  end
end

function addModdedWall(ctype)
  for i=1,#walls,1 do
    if walls[i] == ctype then
      return
    end
  end
  walls[#walls + 1] = ctype
end

function getCellLabelById(id)
  if initialCells[id] ~= nil then
    return "vanilla"
  end
  return cellLabels[id] or "unknown"
end

function getCellIDByLabel(label)
  for id,val in pairs(cellLabels) do
    if val == label then
      return id
    end
  end
end

function rotateCell(x, y, amount)
  cells[y][x].rot = (cells[y][x].rot+amount)%4
end

function getCellLabel(x, y)
  local id = cells[y][x].ctype
  return getCellLabelById(id)
end

function addCell(label, texture, push, ctype, invisible, index, weight)
  if label == "vanilla" or label == "unknown" then
    error("Invalid label for custom cell")
  end
  local cellID = #cellsForIDManagement+1
  tex[cellID] = love.graphics.newImage(texture)
  invisible = invisible or false
  if invisible == false then
    if not index then
      listorder[#listorder+1] = cellID
    elseif type(index) == "number" then
      table.insert(listorder, index, cellID)
    end
  end
  pushabilitySheet[cellID] = push
  cellLabels[cellID] = label
  cellsForIDManagement[#cellsForIDManagement+1] = cellID
  if weight ~= nil then
    cellWeights[cellID] = weight
  end
  ctype = ctype or "normal"
  if ctype == "mover" then
    moddedMovers[cellID] = true
  elseif ctype == "enemy" then
    moddedBombs[cellID] = true
  elseif ctype == "trash" then
    moddedTrash[cellID] = true
  end
  for k,v in pairs(tex) do
    texsize[k] = {}
    texsize[k].w = tex[k]:getWidth()
    texsize[k].h = tex[k]:getHeight()
    texsize[k].w2 = tex[k]:getWidth()/2	--for optimization
    texsize[k].h2 = tex[k]:getHeight()/2
  end
  moddedIDs[#moddedIDs+1] = cellID
  return cellID
end

function canPushCell(cx, cy, px, py, pushing)
  if (not cx) or (not cy) then
    return false
  end
  if cx < 1 or cx > width-1 or cy < 1 or cy > height-1 then
    return false
  end
  local cdir = cells[cy][cx].rot
  local pdir = cells[py][px].rot
  local ctype = cells[cy][cx].ctype
  if pushabilitySheet[ctype] == nil then
    return false
  end
  return pushabilitySheet[ctype](cx, cy, cdir, px, py, pdir, pushing)
end