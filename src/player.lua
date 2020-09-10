Player = {}

Player.PUNCH_DURATION = 1 / 3
Player.PUNCH_AFTER_DELAY = Player.PUNCH_DURATION

function Player:new(x, y)
  local that = {}

  that.x = x
  that.y = y
  that.speed = 4

  that.imageWidth = 64
  that.imagePunchWidth = 96
  that.imageHeight = 96

  that.runningAnimation = Util.newAnimation(love.graphics.newImage("assets/dog-run.png"), that.imageWidth, that.imageHeight, 1 / 3)
  that.punchingAnimation = Util.newAnimation(love.graphics.newImage("assets/dog-punch.png"), that.imagePunchWidth, that.imageHeight, Player.PUNCH_DURATION)
  that.standingAnimation = love.graphics.newImage("assets/dog-stand.png")

  that.punch = 0
  that.punchDelay = 0

  that.isWalking = false

  self.__index = self
  return setmetatable(that, self)
end

function Player:getEndX()
  return self.imageWidth
end

function Player:getEndY()
  return self.imageHeight
end

function Player:getSpeed()
  return self.speed
end

function Player:getIsPunching()
  return self.punch > 0
end

function Player:update(dt, Keys)
  local originalX = self.x
  local originalY = self.y

  for key, value in pairs(Keys) do
    if value == true then
      if key == 'up' then
        self.y = self.y - self:getSpeed()
      elseif key == 'down' then
        self.y = self.y + self:getSpeed()
      elseif key == 'left' then
        self.x = self.x - self:getSpeed()
      elseif key == 'right' then
        self.x = self.x + self:getSpeed()
      elseif key == 'space' then
        if not self:getIsPunching() and self.punchDelay <= 0 then
          self.punch = dt
        end
      end
    end
  end

  -- Punch happening
  if self.punch > 0 and self.punch < Player.PUNCH_DURATION and self.punchDelay <= 0 then
    self.punch = self.punch + dt
    Util.advanceAnimationFrame(self.punchingAnimation, dt)
  end

  -- Ended punch
  if self.punch >= Player.PUNCH_DURATION then
    self.punch = 0
    self.punchDelay = Player.PUNCH_AFTER_DELAY
  end

  -- Delay after punch
  if self.punchDelay > 0 then
    self.punchDelay = self.punchDelay - dt
  end

  self.isWalking = originalX ~= self.x or originalY ~= self.y
  Util.advanceAnimationFrame(self.runningAnimation, dt)
end

function Player:draw()
  if self:getIsPunching() then
    local spriteNum = math.floor(self.punchingAnimation.currentTime / self.punchingAnimation.duration * #self.punchingAnimation.quads) + 1
    love.graphics.draw(self.punchingAnimation.spriteSheet, self.punchingAnimation.quads[spriteNum], self.x, self.y, 0)
  elseif self.isWalking then
    local spriteNum = math.floor(self.runningAnimation.currentTime / self.runningAnimation.duration * #self.runningAnimation.quads) + 1
    love.graphics.draw(self.runningAnimation.spriteSheet, self.runningAnimation.quads[spriteNum], self.x, self.y, 0)
  else
    love.graphics.draw(self.standingAnimation, self.x, self.y, 0)
  end
end

return Player