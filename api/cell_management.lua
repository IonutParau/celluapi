pushabilitySheet = {}
moddedMovers = {}
moddedBombs = {}
moddedTrash = {}
cellsForIDManagement = {}
cellLabels = {}

function getCellLabelById(id)
  if initialCells[id] ~= nil then
    return "vanilla"
  end
  return cellLabels[id] or "unknown"
end

function rotateCell(x, y, amount)
  cells[y][x].rot = (cells[y][x].rot+amount)%4
end

function getCellLabel(x, y)
  local id = cells[y][x].ctype
  return getCellLabelById(id)
end

function addCell(label, texture, push, type, invisible)
  if label == "vanilla" or label == "unknown" then
    error("Invalid label for custom cell")
  end
  local cellID = #cellsForIDManagement+1
  tex[cellID] = love.graphics.newImage(texture)
  invisible = invisible or false
  if invisible == false then
    listorder[#listorder+1] = cellID
  end
  pushabilitySheet[cellID] = push
  cellLabels[cellID] = label
  cellsForIDManagement[#cellsForIDManagement+1] = cellID
  type = type or "normal"
  if type == "mover" then
    moddedMovers[cellID] = true
  end
  if type == "enemy" then
    moddedBombs[cellID] = true
  end
  if type == "trash" then
    moddedTrash[cellID] = true
  end
  for k,v in pairs(tex) do
    texsize[k] = {}
    texsize[k].w = tex[k]:getWidth()
    texsize[k].h = tex[k]:getHeight()
    texsize[k].w2 = tex[k]:getWidth()/2	--for optimization
    texsize[k].h2 = tex[k]:getHeight()/2
  end
  return cellID
end

function canPushCell(cx, cy, px, py, pushing)
  local cdir = cells[cy][cx].rot
  local pdir = cells[py][px].rot
  local ctype = cells[cy][cx].ctype
  if pushabilitySheet[ctype] == nil then
    return nil
  end
  return pushabilitySheet[ctype](cx, cy, cdir, px, py, pdir, pushing)
end