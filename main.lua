push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 232

PADDLE_SPEED = 200

Class = require 'class'

require 'Paddle'

require 'Ball'

function love.load() 

  love.graphics.setDefaultFilter('nearest', 'nearest') -- filter for retro game

  font = love.graphics.newFont('font.ttf', 16) -- better font for 2d game
  love.graphics.setFont(font)

  -- set virtual window for better and consistant resolution whatever the window size is
  push:setupScreen( VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = true,
    vsync = true
  })

  function love.resize(w, h)
    return push:resize(w, h)
  end

  player1paddle = Paddle(5, VIRTUAL_HEIGHT / 3, 5, 20)
  player2paddle = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT / 1.5, 5, 20)

  ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 + 2, 4, 4)

  gameState = 'start'
end

function love.update(dt) 
  -- player 1
  if love.keyboard.isDown('w') then
    player1paddle.dy = -PADDLE_SPEED
  elseif love.keyboard.isDown('s') then
    player1paddle.dy = PADDLE_SPEED 
  else
    player1paddle.dy = 0 -- if no keyboard pressed paddle stays in its place
  end
  -- player 2
  if love.keyboard.isDown('up') then
    player2paddle.dy = -PADDLE_SPEED 
  elseif love.keyboard.isDown('down') then
    player2paddle.dy = PADDLE_SPEED 
  else
    player2paddle.dy = 0 -- if no keyboard pressed paddle stays in its place
  end

  player1paddle:update(dt)
  player2paddle:update(dt)    
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  elseif key == 'enter' or key == 'return' then
    if gameState == 'start' then
      gameState = 'play'
    else
      gameState = 'start'
    end
  end
end

function love.draw() 
  push:start()
  
  if gameState == 'start' then
    love.graphics.printf(
      'Press enter to begin',
      0,                        -- starting x
      VIRTUAL_HEIGHT / 4 - 10,  -- starting y
      VIRTUAL_WIDTH,            -- limit
      'center'                  -- alignment
    )
  else
    love.graphics.printf(
      'The game has begun',
      0,                     
      VIRTUAL_HEIGHT / 4 - 10,  
      VIRTUAL_WIDTH,           
      'center'               
    )
  end
  
  player1paddle:render()
  player2paddle:render()

  ball:render()

  push:finish()
end

