require 'api.config'

function love.conf(t)
	local config = loadConfig()
	t.console = (config['debug'] == 'true')
	t.window.width = 800
	t.window.height = 600
	t.window.resizable = true
	t.window.icon = "icon.png"
	t.window.title = "CelLuAPI Machine"
end