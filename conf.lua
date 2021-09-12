require 'api/api'

function love.conf(t)
	t.console = (config['debug'] == 'true')
	t.window.width = 800
	t.window.height = 600
	t.window.resizable = true
	t.window.icon = "icon.png"
	t.window.title = "CelLuAPI Machine"
end