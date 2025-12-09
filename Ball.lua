Ball = Class{}

function Ball:init(x, y, width, height)
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.dx = 0
  self.dy = 0
end

function Ball:update(dt)
  self.x = self.x + self.dx * dt
  self.y = self.y + self.dy * dt
end

function Ball:collision(player)
  -- AABB collision
  -- if ball is to the left or to the right of the paddle there is no contact
  if ball.x > player.x + player.width or ball.x + ball.width < player.x then
    return false
  end
  -- if ball is above or under paddle there is no contact
  if ball.y > player.y + player.height or ball.y + ball.height < player.y then
    return false
  end
  -- else return true for collision
  return true
end

function Ball:render()
  love.graphics.circle('fill', self.x, self.y, self.width, self.height)
end

function Ball:reset()
  self.x = VIRTUAL_WIDTH / 2 - 2
  self.y = VIRTUAL_HEIGHT / 2 + 2
  self.dx = math.random(2) == 1 and -100 or 100
  self.dy = math.random(-50, 50)
end
