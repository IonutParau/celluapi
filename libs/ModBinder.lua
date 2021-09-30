ModBinder = {}

ModBinder.version = "First-Build"

function ModBinder.bindMod(modName)
  -- This function is for binding a mod
  local mod = {}
  local binding = {}
  binding.bindFunction = function(funcName, func)
    mod[funcName] = func
    return binding
  end
  modcache[modName] = mod
  return binding
end