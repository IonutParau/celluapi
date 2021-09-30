
local json = require "libs.json"
-- This file is gonna be for external mod loading

local isExternal = false

-- Check for signs of external

function loadModLoader()
  local info = {}
  love.filesystem.getInfo("Mods", "directory", info)

  print(json.encode(info))

  if next(info) ~= nil then
    isExternal = true
  end

  if isExternal then
    mods = {}
    for i, file in pairs(love.filesystem.getDirectoryItems('Mods')) do
      local fileSplit = split(file, '.')
			if tostring(fileSplit[#fileSplit]) == 'lua' and file ~= "main.lua" and file ~= "conf.lua" then
				mods[#mods+1] = fileSplit[1]
			end
    end
  end
end

function getCorrectPath(p)
  local sep = "/"
  -- local os = love.system.getOS()
  -- if string.sub(os, 1, string.len("Windows")) == "Windows" then
  --   sep = "\\"
  -- end
  if p == "" then
    return love.filesystem.getSaveDirectory() .. sep .. "Mods"
  end
  if isExternal == true then
    return love.filesystem.getSaveDirectory() .. sep .. "Mods" .. sep .. p
  end
  return p
end

function external()
  return false --isExternal
end