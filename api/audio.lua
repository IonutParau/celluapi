audiocache = {}

function playSound(sound)
  if audiocache[sound] == nil then
    audiocache[sound] = love.audio.newSource(sound, "static")
  end
  love.audio.play(audiocache[sound])
end