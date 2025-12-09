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

  smallFont = love.graphics.newFont('font.ttf', 16) -- better font for 2d game

  bigFont = love.graphics.newFont('font.ttf', 32) 

  math.randomseed(os.time())

  -- set virtual window for better and consistant resolution whatever the window size is
  push:setupScreen( VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = true,
    vsync = true
  })

  function love.resize(w, h)
    return push:resize(w, h)
  end

  scorePlayer1 = 0
  scorePlayer2 = 0

  player1paddle = Paddle(5, VIRTUAL_HEIGHT / 3, 5, 20)
  player2paddle = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT / 1.5, 5, 20)

  ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 + 2, 4, 4)

  ball.dx = math.random(2) == 1 and -100 or 100
  ball.dy = math.random(2) == 1 and math.random(-80, -100) or math.random(80, 100)

  gameState = 'start'
end

function love.update(dt) 
  -- ball collision with paddle1
  if ball:collision(player1paddle) then
    ball.dx = -ball.dx * 1.03             -- change direction and increases velocity
    ball.x = ball.x + player1paddle.width -- moves ball away from paddle to avoid a collision loop

    -- does not change y direction just its velocity
    if ball.dy < 0 then
      ball.dy = -math.random(10,150)
    else
      ball.dy = math.random(10,150)
    end
  end
  -- ball collision with paddle2
  if ball:collision(player2paddle) then
    ball.dx = -ball.dx * 1.03
    ball.x = ball.x - ball.width

    if ball.y < 0 then
      ball.dy = -math.random(10,150)
    else
      ball.dy = math.random(10,150)
    end
  end
  -- ball collision with top and botton 
  if ball.y <= ball.height or ball.y >= VIRTUAL_HEIGHT - ball.height then 
    ball.dy = -ball.dy -- change direction
  end

  -- scores
  if ball.x < 0 then
    scorePlayer1 = scorePlayer1 + 1

    gameState = 'start'
    ball:reset()
  elseif ball.x > VIRTUAL_WIDTH then
    scorePlayer2 = scorePlayer2 + 1

    gameState = 'start'
    ball:reset()
  end  
  -- player 1 movement
  if love.keyboard.isDown('w') then
    player1paddle.dy = -PADDLE_SPEED
  elseif love.keyboard.isDown('s') then
    player1paddle.dy = PADDLE_SPEED 
  else
    player1paddle.dy = 0 -- if no keyboard pressed paddle stays in its place
  end
  -- player 2 movement
  if love.keyboard.isDown('up') then
    player2paddle.dy = -PADDLE_SPEED 
  elseif love.keyboard.isDown('down') then
    player2paddle.dy = PADDLE_SPEED 
  else
    player2paddle.dy = 0 -- if no keyboard pressed paddle stays in its place
  end

  player1paddle:update(dt)
  player2paddle:update(dt)

  if gameState == 'play' then
    ball:update(dt)   
  end
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  elseif key == 'enter' or key == 'return' then
    if gameState == 'start' then
      gameState = 'play'
    else
      gameState = 'start'

      ball:reset()
    end
  end
end

function love.draw() 
  push:start()
  
  love.graphics.setFont(smallFont)
  if gameState == 'start' then
    love.graphics.printf(
      'Game Start State',
      0,                        -- starting x
      VIRTUAL_HEIGHT / 5,  -- starting y
      VIRTUAL_WIDTH,            -- limit
      'center'                  -- alignment
    )
  else
    love.graphics.printf(
      'Game Play State',
      0,                     
      VIRTUAL_HEIGHT / 5,  
      VIRTUAL_WIDTH,           
      'center'               
    )
  end

  love.graphics.setFont(bigFont)
  love.graphics.printf(scorePlayer1, 150, VIRTUAL_HEIGHT / 3 - 10, VIRTUAL_WIDTH, 'left')
  love.graphics.printf(scorePlayer2, 0, VIRTUAL_HEIGHT / 3 - 10, VIRTUAL_WIDTH - 150, 'right')

  player1paddle:render()
  player2paddle:render()

  ball:render()

  push:finish()
end

