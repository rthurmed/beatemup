HitBox = {}

function HitBox:new(player, x, y, h, w)
  local that = {}

  that.player = player

  that.x = x or 0
  that.y = y or 0
  that.h = h or 0
  that.w = w or 0

  self.__index = self
  return setmetatable(that, self)
end

function HitBox:getStartX()
  return self.player.x + self.x
end

function HitBox:getStartY()
  return self.player.y + self.y
end

function HitBox:getEndX()
  return self:getStartX() + self.w
end

function HitBox:getEndY()
  return self:getStartY() + self.h
end

function HitBox:draw()
  love.graphics.rectangle('line', self:getStartX(), self:getStartY(), self.w, self.h)
end

return HitBox