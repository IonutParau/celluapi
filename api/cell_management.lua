pushabilitySheet = {}
moddedMovers = {}
cellLabels = {}

function getCellLabelById(id)
  if initialCells[id] ~= nil then
    return "vanilla"
  elseif cellLabels[id] ~= nil then
    return cellLabels[id]
  else
    return "unknown"
  end
end

function rotateCell(x, y, amount)
  cells[y][x].rot = (cells[y][x].rot+amount)%4
end

function getCellLabel(x, y)
  local id = cells[y][x].ctype
  return getCellLabelById(id)
end

function addCell(label, texture, push, isMover)
  if label == "vanilla" or label == "unknown" then
    error("Invalid label for custom cell")
  end
  local cellID = #listorder+1
  tex[cellID] = love.graphics.newImage(texture)
  listorder[#listorder+1] = cellID
  pushabilitySheet[cellID] = push
  cellLabels[cellID] = label
  if isMover == true then
    moddedMovers[cellID] = isMover
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