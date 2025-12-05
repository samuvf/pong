push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 232

function love.load() 

  love.graphics.setDefaultFilter('nearest', 'nearest') -- filter for retro game

  smallFont = love.graphics.newFont('font.ttf', 8) -- better font for 2d game
  
  love.graphics.setFont(smallFont) 

  -- set virtual window for better and consistant resolution whatever the window size is
  push:setupScreen( VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = true,
    vsync = true
  })

  function love.resize(w, h)
    return push:resize(w, h)
  end

end

function love.update(dt) 
  function love.keypressed(key)
    if key == 'escape' then
      love.event.quit()
    end
  end
end

function love.draw() 
  push:start()
    
  love.graphics.printf(
    'Welcome to Pong!',
    0,                      -- starting x
    VIRTUAL_HEIGHT / 2 - 6,  -- starting y
    VIRTUAL_WIDTH,           -- limit
    'center'                -- alignment
  )

  push:finish()
end