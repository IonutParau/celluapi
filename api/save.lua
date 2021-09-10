function split(s, delimiter)
  local result = {''}
  for i=1,string.len(s) do
      if string.sub(s, i, i) == delimiter then
        table.insert(result, '')
      else
        result[#result] = result[#result] .. string.sub(s, i, i)
      end
  end
  return result
end

function decimalToHex(num)
  if num == 0 then
      return '0'
  end
  local neg = false
  if num < 0 then
      neg = true
      num = num * -1
  end
  local hexstr = "0123456789ABCDEF"
  local result = ""
  while num > 0 do
      local n = math.mod(num, 16)
      result = string.sub(hexstr, n + 1, n + 1) .. result
      num = math.floor(num / 16)
  end
  if neg then
      result = '-' .. result
  end
  return result
end

-- Encode the single cell
function encodeAP1Cell(cell, count)
  local id
  local strcount = decimalToHex(count)
  local properties = ""
  if cell.placeable then
    properties = properties .. "+"
  end
  if cell.ctype > initialCellCount then
    -- It is modded, do modded encoding
    id = 'm|' .. getCellLabelById(cell.ctype)
  else
    -- It is vanilla, do vanilla encoding
    id = 'v|' .. decimalToHex(cell.ctype)
  end
  local str = id .. "|" .. cell.rot .. "|" .. strcount .. "|" .. properties
  return str
end

function CopyTable(table)
  local copy = {}
  for k, v in pairs(table) do
    copy[k] = v
  end
  return copy
end

-- Encode the whole grid
function encodeAP1()
  local str = "AP1;"
  str = str .. decimalToHex(width) .. ';'
  str = str .. decimalToHex(height) .. ';'
  local cellList = {

  }

  local cellCounts = {

  }

  for y=1,height-2,1 do
    for x=1,width-2,1 do
      local cellToEncode = {
        ctype = cells[y][x].ctype,
        rot = cells[y][x].rot,
        placeable = placeables[y][x]
      }
      if #cellList > 0 then
        local prevcell = CopyTable(cellList[#cellList])
        if encodeAP1Cell(prevcell, 1) == encodeAP1Cell(cellToEncode, 1) then
          cellCounts[#cellCounts] = cellCounts[#cellCounts] + 1
        else
          table.insert(cellList, cellToEncode)
          table.insert(cellCounts, 1)
        end
      else
        table.insert(cellList, cellToEncode)
        table.insert(cellCounts, 1)
      end
    end
  end

  for i=1, #cellList, 1 do
    str = str .. encodeAP1Cell(cellList[i], cellCounts[i]) .. ';'
  end

  love.system.setClipboardText(str)
end

-- Decode the whole grid
function DecodeAP1(str)
  local code = split(str, ';')
  width = tonumber(code[2], 16)
  height = tonumber(code[3], 16)
  code[#code] = nil

  local cellList = {}

  for k, v in pairs(code) do
    if k > 3 then
      -- Decode the cell
      local thingies = split(v, '|')
      local id
      if thingies[1] == "v" then
        id = tonumber(thingies[2], 16)
      elseif thingies[1] == "m" then
        id = getCellIDByLabel(thingies[2])
      end
      local cell = {
        id = id,
        rot = tonumber(thingies[3]),
        placeable = false
      }
      for i=1,str.len(thingies[5] or '') do
        if str.sub(thingies[5], i, i) == "+" then
          cell.placeable = true
        end
      end
      local count = tonumber(thingies[4], 16)
      for i=1,count do
        table.insert(cellList, cell)
      end
    end
  end
  local i = 0
  for y=1,height-2 do
		for x=1,width-2 do
			i = i + 1
      cells[y][x].ctype = cellList[i].id
      cells[y][x].rot = cellList[i].rot
      initial[y][x].ctype = cellList[i].id
      initial[y][x].rot = cellList[i].rot
      placeables[y][x] = cellList[i].placeable
		end
	end
  bgsprites = love.graphics.newSpriteBatch(tex[0])
  for y=0,height-1 do
		for x=0,width-1 do
			if y == 0 or x == 0 or y == height-1 or x == width-1 then
				initial[y][x].ctype = walls[border]
			end
			cells[y][x].ctype = initial[y][x].ctype
			cells[y][x].rot = initial[y][x].rot
			cells[y][x].lastvars = {x,y,cells[y][x].rot}
			cells[y][x].testvar = ""
			bgsprites:add((x-1)*20,(y-1)*20)
		end
	end
  RefreshChunks()
end