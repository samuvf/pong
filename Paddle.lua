Paddle = Class{}

function Paddle:init(x, y, width, height)
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.dy = 0 -- responsible for the velocity and directiion of the paddle
end

function Paddle:update(dt)
  -- paddle can't pass the top
  if self.dy < 0 then
    self.y = math.max(0, self.y + self.dy * dt)
  -- nor the botton of the screen
  else
    self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy  * dt)
  end
end

function Paddle:render()
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end