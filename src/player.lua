HitBox = require('src/hitbox')

Player = {}

Player.SPEED_RUNNING = 4

Player.ACCEL_FORWARD = 1.2
Player.ACCEL_DEFAULT = 0.8

Player.CENTER_OFFSET = 72

Player.PUNCH_DURATION = 1 / 3
Player.PUNCH_AFTER_DELAY = Player.PUNCH_DURATION

Player.PUNCH_HITBOX_X = 52
Player.PUNCH_HITBOX_y = 0
Player.PUNCH_HITBOX_HEIGHT = 44
Player.PUNCH_HITBOX_WIDTH = 44

function Player:new(stage)
  local that = {}

  that.stage = stage

  that.x = stage.playerStartX
  that.y = stage.playerStartY
  that.speed = Player.SPEED_RUNNING

  that.imageWidth = 64
  that.imagePunchWidth = 96
  that.imageHeight = 96

  that.runningAnimation = Util.newAnimation(love.graphics.newImage("assets/player-run.png"), that.imageWidth, that.imageHeight, 1 / 3)
  that.punchingAnimation = Util.newAnimation(love.graphics.newImage("assets/player-punch.png"), that.imagePunchWidth, that.imageHeight, Player.PUNCH_DURATION)
  that.standingAnimation = love.graphics.newImage("assets/player-stand.png")

  that.punch = 0
  that.punchDelay = 0

  that.damagebox = nil

  that.isWalking = false

  self.__index = self
  return setmetatable(that, self)
end

function Player:getEndX()
  return self.x + self.imageWidth
end

function Player:getEndY()
  return self.y + self.imageHeight
end

function Player:getSpeed()
  return self.speed
end

function Player:getIsPunching()
  return self.punch > 0
end

function Player:moveX(m)
  local newX = self.x + m * self:getSpeed()
  local newEndXOffsetRight = newX + self.imageWidth + Player.CENTER_OFFSET
  local halfWidth = love.graphics.getWidth() / 2

  if newEndXOffsetRight > halfWidth and self.stage.backgroundX > -self.stage.backgroundFullWidth + self.stage.backgroundWidth then
    self.stage.backgroundX = self.stage.backgroundX - m * self:getSpeed()
  elseif newEndXOffsetRight < halfWidth and self.stage.backgroundX < 0 then
    self.stage.backgroundX = self.stage.backgroundX - m * self:getSpeed()
  elseif newX > 0 and newEndXOffsetRight < love.graphics.getWidth() then
    self.x = newX
  end
end

function Player:moveY(m)
  local newY = self.y + m * self:getSpeed()
  local newYBottom = newY + self.imageHeight

  if newYBottom > self.stage.verticalLimitTop and newYBottom < self.stage.verticalLimitBottom then
    self.y = newY
  end
end

function Player:update(dt, Keys)
  local originalX = self.x
  local originalY = self.y
  local originalBackgroundX = self.stage.backgroundX

  for key, value in pairs(Keys) do
    if value == true then
      if key == 'up' then
        self:moveY(-Player.ACCEL_DEFAULT)
      elseif key == 'down' then
        self:moveY(Player.ACCEL_DEFAULT)
      elseif key == 'left' then
        self:moveX(-Player.ACCEL_DEFAULT)
      elseif key == 'right' then
        self:moveX(Player.ACCEL_FORWARD)
      elseif key == 'space' then
        -- Start punch
        if not self:getIsPunching() and self.punchDelay <= 0 then
          self.punch = dt
          self.damagebox = HitBox:new(self, Player.PUNCH_HITBOX_X, Player.PUNCH_HITBOX_Y, Player.PUNCH_HITBOX_HEIGHT, Player.PUNCH_HITBOX_WIDTH)
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
    self.damagebox = nil
  end

  -- Delay after punch
  if self.punchDelay > 0 then
    self.punchDelay = self.punchDelay - dt
  end

  self.isWalking = originalX ~= self.x or originalY ~= self.y or originalBackgroundX ~= self.stage.backgroundX
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

  if self.damagebox ~= nil then
    self.damagebox:draw()
  end
end

return Player