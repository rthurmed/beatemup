HitBox = require('src/hitbox')
Util = require('util')

Enemy = {}

Enemy.SPEED_RUNNING = 4

Enemy.ACCEL_FORWARD = 1.2
Enemy.ACCEL_DEFAULT = 0.8

Enemy.CENTER_OFFSET = 72

Enemy.PUNCH_DURATION = 1 / 3
Enemy.PUNCH_AFTER_DELAY = Enemy.PUNCH_DURATION

Enemy.PUNCH_HITBOX_X = 52
Enemy.PUNCH_HITBOX_y = 0
Enemy.PUNCH_HITBOX_HEIGHT = 44
Enemy.PUNCH_HITBOX_WIDTH = 44

Enemy.PUNCH_SAFE_DISTANCE = 108
Enemy.PUNCH_ATTACK_DISTANCE = 16

Enemy.FRIEND_CLOSENESS = 32

Enemy.VIEW_RANGE = 200

Enemy.LIFE_DEFAULT = 1

function Enemy:new(stage, x, y)
  local that = {}

  that.stage = stage

  that.x = x
  that.y = y
  that.speed = Enemy.SPEED_RUNNING

  that.imageWidth = 64
  that.imagePunchWidth = 96
  that.imageHeight = 96

  that.runningAnimation = Util.newAnimation(love.graphics.newImage("assets/enemy-run.png"), that.imageWidth, that.imageHeight, 1 / 3)
  that.punchingAnimation = Util.newAnimation(love.graphics.newImage("assets/enemy-punch.png"), that.imagePunchWidth, that.imageHeight, Enemy.PUNCH_DURATION)
  that.standingAnimation = love.graphics.newImage("assets/enemy-stand.png")

  that.punch = 0
  that.punchDelay = 0

  that.life = Player.LIFE_DEFAULT

  that.hitbox = nil
  that.damagebox = nil

  that.isFacingRight = false

  that.isWalking = false

  self.__index = self
  return setmetatable(that, self)
end

function Enemy:getRelativeX()
  return self.x + self.stage.backgroundX
end

function Enemy:getEndX()
  return self.x + self.imageWidth
end

function Enemy:getEndY()
  return self.y + self.imageHeight
end

function Enemy:getHitbox()
  return HitBox:new(self, self.stage.backgroundX, 0, self.imageHeight, self.imageWidth)
end

function Enemy:getSpeed()
  return self.speed
end

function Enemy:getIsPunching()
  return self.punch > 0
end

function Enemy:moveX(m)
  local newX = self.x + m * self:getSpeed()
  self.x = newX
end

function Enemy:moveY(m)
  local newY = self.y + m * self:getSpeed()
  self.y = newY
end

function Enemy:think()
  local distance = Util.distance(self:getRelativeX(), self.y, self.stage.player.x, self.stage.player.y)
  if distance < Enemy.VIEW_RANGE then
    if self.y > self.stage.player.y then
      self:moveY(-Enemy.ACCEL_DEFAULT)
    end

    if self.y < self.stage.player.y then
      self:moveY(Enemy.ACCEL_DEFAULT)
    end

    if self.stage.player.x < self:getRelativeX() - Enemy.PUNCH_SAFE_DISTANCE then
      self:moveX(-Enemy.ACCEL_DEFAULT)
    end

    if self.stage.player.x > self:getRelativeX() + Enemy.PUNCH_SAFE_DISTANCE then
      self:moveX(Enemy.ACCEL_DEFAULT)
    end

    self.isFacingRight = self:getRelativeX() < self.stage.player.x
  end
end

function Enemy:update(dt)
  local originalX = self.x
  local originalY = self.y
  local originalBackgroundX = self.stage.backgroundX

  self:think()

  -- Punch happening
  if self.punch > 0 and self.punch < Enemy.PUNCH_DURATION and self.punchDelay <= 0 then
    self.punch = self.punch + dt
    Util.advanceAnimationFrame(self.punchingAnimation, dt)
  end

  -- Ended punch
  if self.punch >= Enemy.PUNCH_DURATION then
    self.punch = 0
    self.punchDelay = Enemy.PUNCH_AFTER_DELAY
    self.damagebox = nil
  end

  -- Delay after punch
  if self.punchDelay > 0 then
    self.punchDelay = self.punchDelay - dt
  end

  self.isWalking = originalX ~= self.x or originalY ~= self.y or originalBackgroundX ~= self.stage.backgroundX
  Util.advanceAnimationFrame(self.runningAnimation, dt)
end

function Enemy:draw()
  local relativeX = self:getRelativeX()
  local direction = self.isFacingRight and 1 or -1

  local adjustedX = self.isFacingRight and relativeX or relativeX + self.imageWidth

  if self:getIsPunching() then
    local spriteNum = math.floor(self.punchingAnimation.currentTime / self.punchingAnimation.duration * #self.punchingAnimation.quads) + 1
    love.graphics.draw(self.punchingAnimation.spriteSheet, self.punchingAnimation.quads[spriteNum], adjustedX, self.y, 0, direction, 1)
  elseif self.isWalking then
    local spriteNum = math.floor(self.runningAnimation.currentTime / self.runningAnimation.duration * #self.runningAnimation.quads) + 1
    love.graphics.draw(self.runningAnimation.spriteSheet, self.runningAnimation.quads[spriteNum], adjustedX, self.y, 0, direction, 1)
  else
    love.graphics.draw(self.standingAnimation, adjustedX, self.y, 0, direction, 1)
  end

  self:getHitbox():draw()

  if self.damagebox ~= nil then
    self.damagebox:draw()
  end
end

return Enemy