-- allow us to draw our game in a virtual resolution
-- provides a more retro aesthetic

-- https://github.com/Ulydev/push
push = require 'push'
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'class'
require 'Paddle'
require 'Ball'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 232

PADDLE_SPEED = 200

function love.load() 

  love.graphics.setDefaultFilter('nearest', 'nearest') -- takes away the blurriness

  love.window.setTitle('Pong')
  -- load retro fonts
  smallFont = love.graphics.newFont('font.ttf', 8) 
  bigFont = love.graphics.newFont('font.ttf', 16) 
  scoreFont = love.graphics.newFont('font.ttf', 32)
  love.graphics.setFont(smallFont)

  sounds = {
    ['paddle_hit'] = love.audio.newSource('sounds/paddle.wav', 'static'),
    ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
    ['wall_hit'] = love.audio.newSource('sounds/wall.wav', 'static')
  }

  math.randomseed(os.time())

  -- set virtual window for better and consistant resolution whatever the window size is
  push:setupScreen( VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = true,
    vsync = true
  })
  -- initialize player paddles
  player1paddle = Paddle(5, 30, 5, 20)
  player2paddle = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)
  -- initialize ball in the middle of the screen
  ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)
  
  scorePlayer1 = 0
  scorePlayer2 = 0

  -- player that was score gains advantage
  servingPlayer = 1
  -- winning flag
  winnerPlayer = 0


  gameState = 'start'
end

function love.resize(w, h)
  return push:resize(w, h)
end

function love.update(dt) 
  if gameState == 'serve' then
    if servingPlayer == 1 then
      ball.dx = math.random(40, 200)
    elseif servingPlayer == 2 then
      ball.dx = -math.random(40, 200)
    end
    ball.dy = math.random(-50, 50)
  end

  -- player 2 scores
  if ball.x < 0 then
    scorePlayer2 = scorePlayer2 + 1
    servingPlayer = 1
    gameState = 'serve'
    ball:reset()
    love.audio.play(sounds['score'])
  -- player 1 scores
  elseif ball.x > VIRTUAL_WIDTH then
    scorePlayer1 = scorePlayer1 + 1
    servingPlayer = 2
    gameState = 'serve'
    ball:reset()
    love.audio.play(sounds['score'])
  end  

  -- winner player
  if scorePlayer1 == 10 then
    scorePlayer1 = 0
    scorePlayer2 = 0

    winnerPlayer = 1
    gameState = 'done'
  elseif scorePlayer2 == 10 then
    scorePlayer1 = 0
    scorePlayer2 = 0

    winnerPlayer = 2
    gameState = 'done'
  end

  -- ball collision with paddle1
  if ball:collision(player1paddle) then
    ball.dx = -ball.dx * 1.05             -- change direction and increases velocity
    ball.x = ball.x + player1paddle.width -- moves ball away from paddle to avoid a collision loop

    -- does not change y direction just its velocity
    if ball.dy < 0 then
      ball.dy = -math.random(10,150)
    else
      ball.dy = math.random(10,150)
    end
    love.audio.play(sounds['paddle_hit'])
  end
  -- ball collision with paddle2
  if ball:collision(player2paddle) then
    ball.dx = -ball.dx * 1.05
    ball.x = ball.x - ball.width

    if ball.dy < 0 then
      ball.dy = -math.random(10,150)
    else
      ball.dy = math.random(10,150)
    end
    love.audio.play(sounds['paddle_hit'])
  end

  -- ball collision with top and botton 
  if ball.y <= 0 then 
    ball.y = 0
    ball.dy = -ball.dy -- change direction
    love.audio.play(sounds['wall_hit'])
  elseif ball.y >= VIRTUAL_HEIGHT then
    ball.y = VIRTUAL_HEIGHT - ball.height
    ball.dy = -ball.dy -- change direction
    love.audio.play(sounds['wall_hit'])
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
  
  if gameState == 'play' then
    ball:update(dt)
  end

  player1paddle:update(dt)
  player2paddle:update(dt)
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  elseif key == 'enter' or key == 'return' then
    if gameState == 'start' then
      gameState = 'serve'
    elseif gameState == 'serve' then
      gameState = 'play'
    else
      gameState = 'serve'

      ball:reset()
    end
  end
end

function love.draw() 
  push:start()

  love.graphics.clear(40/255, 45/255, 52/255, 255/255)    

  displayFPS()

  if gameState == 'start' then
    love.graphics.setFont(smallFont)
    love.graphics.printf('Welcome to Pong!', 0, 10, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Enter to begin!', 0, 20, VIRTUAL_WIDTH, 'center')
  elseif gameState == 'serve' then
    love.graphics.setFont(smallFont)
    love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s serve!", 
        0, 10, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
  elseif gameState == 'play' then
  else
    love.graphics.setFont(bigFont)
    love.graphics.printf('Player ' .. tostring(winnerPlayer) .. ' wins!', 0, 10, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(smallFont)
    love.graphics.printf('Press Enter to restart!', 0, 30, VIRTUAL_WIDTH, 'center')
  end

  displayScore()

  player1paddle:render()
  player2paddle:render()

  ball:render()

  push:finish()
end

function displayScore()
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(scorePlayer1), VIRTUAL_WIDTH / 2 - 50,  VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(scorePlayer2), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
end

function displayFPS() 
  love.graphics.setFont(smallFont)
  love.graphics.setColor(0, 1, 0, 1)
  love.graphics.print("FPS:" .. tostring(love.timer.getFPS()), 10, 10)
  love.graphics.setColor(1, 1, 1, 1)
end