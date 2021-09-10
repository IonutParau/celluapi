cm = require "api/cell_management"
audio = require "api/audio"
save = require "api/save"

config = {}

function loadConfig()
	local lines = {}
	for line in love.filesystem.lines("api.config") do
		table.insert(lines, line)
	end
	for i=1,#lines,1 do
		local code = split(lines[i], '=')
		config[code[1]] = code[2]
	end
end

mods = {}
initialCellCount = 0
initialCells = {}
loadConfig()
if config['auto_detect_mods'] == 'true' then
	local files = {}
	local e = ""
	for _, file in pairs(love.filesystem.getDirectoryItems('')) do
		local fileSplit = split(file, '.')
		if tostring(fileSplit[#fileSplit]) == 'lua' then
			files[#files+1] = fileSplit[1]
		end
	end
	for _, mod in pairs(files) do
		if mod ~= 'main' and mod ~= 'conf' then
			mods[#mods+1] = mod	
		end
	end
else
	for line in love.filesystem.lines('mods.txt') do 
		mods[#mods+1] = line
	end
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

moddedIDs = {}
walls = {-1, 40, 11, 50}

function UpdateModdedCells()
  for i=1,#moddedIDs,1 do
		local id = moddedIDs[i]
		local x,y = width-1,height-1
		while x >= 0 do
			while y >= 0 do
				if not GetChunk(x, y).hasmodded then GetChunk(x, y).hasmodded = {} end
				if GetChunk(x,y).hasmodded[id] ~= nil then
					if not cells[y][x].updated and cells[y][x].ctype == id and cells[y][x].rot == 0 then
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
				if GetChunk(x,y).hasmodded[id] ~= nil then
					if not cells[y][x].updated and cells[y][x].ctype == id and cells[y][x].rot == 2 then
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
				if GetChunk(x,y).hasmodded[id] ~= nil then
					if not cells[y][x].updated and cells[y][x].ctype == id and cells[y][x].rot == 3 then
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
				if GetChunk(x,y).hasmodded[id] ~= nil then
					if not cells[y][x].updated and cells[y][x].ctype == id and cells[y][x].rot == 1 then
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
end

function initMods()
	if #mods > 0 then love.window.setTitle(love.window.getTitle() .. " (") end
  for i=1,#mods,1 do
    local mod = require(mods[i])
    if mod.init ~= nil then
			mod.init()
		end
		if i == #mods then
			love.window.setTitle(love.window.getTitle() .. mods[i])
		else
			love.window.setTitle(love.window.getTitle() .. mods[i] .. ",")
		end
  end
	if #mods > 0 then love.window.setTitle(love.window.getTitle() .. ")") end
end

function modsCustomDraw()
  for i=1,#mods,1 do
    local mod = require(mods[i])
    if mod.customdraw ~= nil then
			mod.customdraw()
		end
  end
end

function modsTick()
  for i=1,#mods,1 do
    local mod = require(mods[i])
    if mod.tick ~= nil then
			mod.tick()
		end
  end
end

function modsOnKeyPressed(key, code, continous)
	for i=1,#mods,1 do
		local mod = require(mods[i])
		if mod.onKeyPressed ~= nil then
			mod.onKeyPressed(key, code, continous)
		end
	end
end

function modsOnModEnemyDed(id, x, y, killer, kx, ky)
	for i=1,#mods,1 do
		local mod = require(mods[i])
		if mod.onEnemyDies ~= nil then
			mod.onEnemyDies(id, x, y, killer, kx, ky)
		end
	end
end

function modsOnTrashEat(id, x, y, food, fx, fy)
	for i=1,#mods,1 do
		local mod = require(mods[i])
		if mod.onTrashEats ~= nil then
			mod.onTrashEats(id, x, y, food, fx, fy)
		end
	end
end

function modsOnPlace(id, x, y, rot, original)
	for i=1,#mods,1 do
		local mod = require(mods[i])
		if mod.onPlace ~= nil then
			mod.onPlace(id, x, y, rot, original)
		end
	end
end

function modsOnUnpause()
	for i=1,#mods,1 do
		local mod = require(mods[i])
		if mod.onUnpause ~= nil then
			mod.onUnpause()
		end
	end
end

function modsOnMousePressed(x, y, button, istouch, presses)
	for i=1,#mods,1 do
		local mod = require(mods[i])
		if mod.onMousePressed ~= nil then
			mod.onMousePressed(x, y, button, istouch, presses)
		end
	end
end

function modsOnMouseReleased(x, y, button, istouch, presses)
	for i=1,#mods,1 do
		local mod = require(mods[i])
		if mod.onMouseReleased ~= nil then
			mod.onMouseReleased(x, y, button, istouch, presses)
		end
	end
end

function isModdedTrash(id)
	return (moddedTrash[id] ~= nil)
end

function isModdedBomb(id)
	return (moddedBombs[id] ~= nil)
end