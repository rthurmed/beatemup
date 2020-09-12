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

function HitBox:isTouching(hitbox)
  local overlapX = false
  local overlapY = false

  if self:getStartX() < hitbox:getStartX() then
    overlapX = self.w + self:getStartX() > hitbox:getStartX()
  else
    overlapX = hitbox.w + hitbox:getStartX() > self:getStartX()
  end

  if self:getStartY() < hitbox:getStartY() then
    overlapY = self.h + self:getStartY() > hitbox:getStartY()
  else
    overlapY = hitbox.h + hitbox:getStartY() > self:getStartY()
  end

  return overlapX and overlapY
end

function HitBox:draw()
  if DEBUG then
    love.graphics.rectangle('line', self:getStartX(), self:getStartY(), self.w, self.h)
  end
end

return HitBox