cm = require "api/cell_management"
audio = require "api/audio"
save = require("api/save")
MB = require "libs.ModBinder"
syn = require "libs.Synapse"
conf = require("api.config")
sec = require("api.security")

config = {}
modcache = {}

function checkVersion(mod, version)
	if modcache[mod] == nil then return false end
	if modcache[mod].version == nil then return false end
	if modcache[mod].version == version then return true end

	local comparison = split(split(version, ' ')[1], '.')

	local numcomparison = {}

	for k, v in pairs(comparison) do
		table.insert(numcomparison, tostring(v))
	end

	local ver = split(split(modcache[mod].version, ' ')[1], '.')

	local numver = {}

	for k, v in pairs(ver) do
		table.insert(numver, tostring(v))
	end

	for k, v in pairs(numver) do
		if not numcomparison[k] then return false end

		if v < numcomparison[k] then return false end
	end

	return true
end

function hasMod(mod)
	for k, v in pairs(mods) do
		if v == mod then
			return true
		end
	end
	return false
end

function checkDependencies(d)
	if type(d) == "table" then
		for k, v in pairs(d) do
			if not hasMod(v) then
				error("A mod required another mod as a dependency (" .. v .. " was the dependency) but that mod did not exist.")
			end			
		end
	end
end

function broadcastSignal(sender, signal)
  for name, mod in pairs(modcache) do
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

config = loadConfig()

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
  for _, mod in pairs(modcache) do
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

function initMods(forTests)
	if not forTests then
		if #mods > 0 then love.window.setTitle(love.window.getTitle() .. " (") end
  	for i=1,#mods,1 do
    	local mod = require(mods[i])
			if type(mod) == "table" then
				modcache[mods[i]] = mod
			end
			if i == #mods then
				love.window.setTitle(love.window.getTitle() .. mods[i])
			else
				love.window.setTitle(love.window.getTitle() .. mods[i] .. ",")
			end
  	end
		if #mods > 0 then love.window.setTitle(love.window.getTitle() .. ")") end
	end
	for _, mod in pairs(modcache) do
		if type(mod.dependencies) == "table" then
			checkDependencies(mod.dependencies)
		end
		if type(mod.init) == "function" then
			mod.init()
		end
	end
end

function CopyTable(table)
	local copy = {}
	for k, v in pairs(table) do
		if type(v) == "table" then
			copy[k] = CopyTable(v)
		else
			copy[k] = v
		end
	end
	return copy
end

function modsCustomDraw()
  for _, mod in pairs(modcache) do
    if type(mod.customdraw) == "function" then
			mod.customdraw()
		end
  end
end

function modsTick()
  for _, mod in pairs(modcache) do
    if type(mod.tick) == "function" then
			mod.tick()
		end
  end
end

function modsOnKeyPressed(key, code, continous)
	for _, mod in pairs(modcache) do
		if type(mod.onKeyPressed) == "function" then
			mod.onKeyPressed(key, code, continous)
		end
	end
end

function modsOnModEnemyDed(id, x, y, killer, kx, ky)
	for _, mod in pairs(modcache) do
		if type(mod.onEnemyDies) == "function" then
			mod.onEnemyDies(id, x, y, killer, kx, ky)
		end
	end
end

function modsOnTrashEat(id, x, y, food, fx, fy)
	for _, mod in pairs(modcache) do
		if type(mod.onTrashEats) == "function" then
			mod.onTrashEats(id, x, y, food, fx, fy)
		end
	end
end

function modsOnPlace(id, x, y, rot, original, originalInitial)
	for _, mod in pairs(modcache) do
		if type(mod.onPlace) == "function" then
			mod.onPlace(id, x, y, rot, original, originalInitial)
		end
	end
end

function modsOnUnpause()
	for _, mod in pairs(modcache) do
		if type(mod.onUnpause) == "function" then
			mod.onUnpause()
		end
	end
end

function modsOnMousePressed(x, y, button, istouch, presses)
	for _, mod in pairs(modcache) do
		if type(mod.onMousePressed) == "function" then
			mod.onMousePressed(x, y, button, istouch, presses)
		end
	end
end

function modsOnMouseReleased(x, y, button, istouch, presses)
	for _, mod in pairs(modcache) do
		if type(mod.onMouseReleased) == "function" then
			mod.onMouseReleased(x, y, button, istouch, presses)
		end
	end
end

function modsOnCellDraw(id, x, y, dir)
	for _, mod in pairs(modcache) do
		if type(mod.onCellDraw) == "function" then
			mod.onCellDraw(id, x, y, dir)
		end
	end
end

function modsOnReset()
	for _, mod in pairs(modcache) do
		if type(mod.onReset) == "function" then
			mod.onReset()
		end
	end
end

function modsOnClear()
	for _, mod in pairs(modcache) do
		if type(mod.onClear) == "function" then
			mod.onClear()
		end
	end
end

function modsOnMove(id, x, y, dir)
	for _, mod in pairs(modcache) do
		if type(mod.onMove) == "function" then
			mod.onMove(id, x, y, dir)
		end
	end
end

function modsOnSetInitial()
	for _, mod in pairs(modcache) do
		if type(mod.onSetInitial) == "function" then
			mod.onSetInitial()
		end
	end
end

function modsOnMouseScroll(x, y)
	for _, mod in pairs(modcache) do
		if type(mod.onMouseScroll) == "function" then
			mod.onMouseScroll(x, y)
		end
	end
end

function modsOnCellGenerated(generator, gx, gy, generated, cx, cy)
	for _, mod in pairs(modcache) do
		if type(mod.onCellGenerated) == "function" then
			mod.onCellGenerated(generator, gx, gy, generated, cx, cy)
		end
	end
end

-- Blendi plz no
function modsCustomUpdate(dt)
	for _, mod in pairs(modcache) do
		if type(mod.customupdate) == "function" then
			mod.customupdate(dt)
		end
	end
end

function isModdedTrash(id)
	return (moddedTrash[id] ~= nil)
end

function isModdedBomb(id)
	return (moddedBombs[id] ~= nil)
end