Ball = Class{}

function Ball:init(x, y, width, height)
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  -- these variables are for keeping track of our velocity on both the
  -- X and Y axis, since the ball can move in two dimensions
  self.dx = 0
  self.dy = 0
end

function Ball:update(dt)
  self.x = self.x + self.dx * dt
  self.y = self.y + self.dy * dt
end

function Ball:collision(paddle)
  -- AABB collision
  -- if ball is to the left or to the right of the paddle there is no contact
  if self.x > paddle.x + paddle.width or self.x + self.width < paddle.x then
    return false
  end
  -- if ball is above or under paddle there is no contact
  if self.y > paddle.y + paddle.height or self.y + self.height < paddle.y then
    return false
  end
  -- else return true for collision
  return true
end

function Ball:reset()
  self.x = VIRTUAL_WIDTH / 2 - 2
  self.y = VIRTUAL_HEIGHT / 2 + 2
  self.dx = math.random(2) == 1 and -100 or 100
  self.dy = math.random(-50, 50)
end

function Ball:render()
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end