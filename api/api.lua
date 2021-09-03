cm = require "api/cell_management"
audio = require "api/audio"

mods = {}
initialCellCount = 0
initialCells = {}
for line in love.filesystem.lines('mods.txt') do 
  mods[#mods+1] = line
end

function DoModded(id, x, y, rot)
	cells[y][x].updated = true
  for i=1,#mods,1 do
    local mod = require(mods[i])
    if mod.update ~= nil then
      mod.update(id, x, y, rot)
    end
  end
end

function UpdateModdedCells()
  local x,y = width-1,height-1
	while x >= 0 do
		while y >= 0 do
			if GetChunk(x,y).hasmodded then
				if not cells[y][x].updated and cells[y][x].ctype > initialCellCount and cells[y][x].rot == 0 then
					DoModded(cells[y][x].ctype,x,y,cells[y][x].rot)
				end
				y = y - 1
			else
				y = math.floor(y/25)*25 - 1
			end
		end
		y = height-1
		x = x - 1
	end
	x,y = 0,0
	while x < width do
		while y < height do
			if GetChunk(x,y).hasmodded then
        if not cells[y][x].updated and cells[y][x].ctype > initialCellCount and cells[y][x].rot == 2 then
					DoModded(cells[y][x].ctype,x,y,cells[y][x].rot)
				end
				y = y + 1
			else
				y = y + 25
			end
		end
		y = 0
		x = x + 1
	end
	x,y = 0,0
	while y < height do
		while x < width do
			if GetChunk(x,y).hasmodded then
				if not cells[y][x].updated and cells[y][x].ctype > initialCellCount and cells[y][x].rot == 3 then
					DoModded(cells[y][x].ctype,x,y,cells[y][x].rot)
				end
				x = x + 1
			else
				x = x + 25
			end
		end
		x = 0
		y = y + 1
	end
	x,y = width-1,height-1
	while y >= 0 do
		while x >= 0 do
			if GetChunk(x,y).hasmodded then
				if not cells[y][x].updated and cells[y][x].ctype > initialCellCount and cells[y][x].rot == 1 then
					DoModded(cells[y][x].ctype,x,y,cells[y][x].rot)
				end
				x = x - 1
			else
				x = math.floor(x/25)*25 - 1
			end
		end
		x = width-1
		y = y - 1
	end
end

function initMods()
  for i=1,#mods,1 do
    local mod = require(mods[i])
    mod.init()
  end
end