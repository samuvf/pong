Ball = Class{}

function Ball:init(x, y, width, height, dx, dy)
  self.x = x
  self.y = y
  self.width = width
  self.height  = height
  self.dx = dx
  self.dy = dy
end

function Ball:render()
  love.graphics.circle('fill', self.x, self.y, self.width, self.height)
end
