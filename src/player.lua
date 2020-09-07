Player = {}

function Player:new(x, y, scaleFactor)
  local that = {}

  that.x = x
  that.y = y
  that.speed = 4

  that.imageWidth = 64
  that.imageHeight = 96

  that.runningAnimation = Util.newAnimation(love.graphics.newImage("assets/dog-run.png"), that.imageWidth, that.imageHeight, 1 / 3)
  that.standingAnimation = love.graphics.newImage("assets/dog-stand.png")

  that.isWalking = false

  that.scaleFactor = scaleFactor

  self.__index = self
  return setmetatable(that, self)
end

function Player:getEndX()
  return self.imageWidth * self.y / self.scaleFactor
end

function Player:getEndY()
  return self.imageHeight * self.y / self.scaleFactor
end

function Player:update(dt, Keys)
  local originalX = self.x
  local originalY = self.y

  for key, value in pairs(Keys) do
    if value == true then
      if key == 'up' then
        self.y = self.y - self.speed
      elseif key == 'down' then
        self.y = self.y + self.speed
      elseif key == 'left' then
        self.x = self.x - self.speed
      elseif key == 'right' then
        self.x = self.x + self.speed
      end
    end
  end

  self.isWalking = originalX ~= self.x or originalY ~= self.y

  self.runningAnimation.currentTime = self.runningAnimation.currentTime + dt
  if self.runningAnimation.currentTime >= self.runningAnimation.duration then
      self.runningAnimation.currentTime = self.runningAnimation.currentTime - self.runningAnimation.duration
  end
end

function Player:draw()
  if self.isWalking then
    local spriteNum = math.floor(self.runningAnimation.currentTime / self.runningAnimation.duration * #self.runningAnimation.quads) + 1
    love.graphics.draw(self.runningAnimation.spriteSheet, self.runningAnimation.quads[spriteNum], self.x, self.y, 0, self.y / self.scaleFactor)
  else
    love.graphics.draw(self.standingAnimation, self.x, self.y, 0, self.y / self.scaleFactor)
  end
end

return Player