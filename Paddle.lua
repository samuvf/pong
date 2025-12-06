Paddle = Class{}

function Paddle:init(x, y, width, height, dy)
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.dy = dy
end

function Paddle:render()
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end