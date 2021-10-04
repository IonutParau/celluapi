local plugs = {}

for _, name in pairs(love.filesystem.getDirectoryItems('plugins')) do
  local nameSplit = split(name, '.')
  if #nameSplit > 1 and nameSplit[#nameSplit] == 'lua' then
    local pluginName = nameSplit[1]
    plugs[pluginName] = love.filesystem.load('plugins/' .. name)
  end
end

function GetPlugin(plugin)
  if not plugs[plugin] then return nil end
  
  local copies = {
    listorder = CopyTable(listorder),
    moddedMovers = CopyTable(moddedMovers),
    moddedTrash = CopyTable(moddedTrash),
    moddedIDs = CopyTable(moddedIDs),
    moddedBombs = CopyTable(moddedBombs),
    moddedDivergers = CopyTable(moddedDivergers),
    tex = CopyTable(tex),
    plugingetter = GetPlugin
  }

  local p = plugs[plugin]()

  listorder = copies.listorder
  moddedMovers = copies.moddedMovers
  moddedTrash = copies.moddedTrash
  moddedIDs = copies.moddedIDs
  moddedBombs = copies.moddedBombs

  if #(copies.tex) ~= #tex then
    tex = copies.tex
  end

  GetPlugin = copies.plugingetter
  
  return p
end