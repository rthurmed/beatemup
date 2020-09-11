Player = require('src/player')

Stage = {}

function Stage:new()
  local that = {}

  that.backgroundImage = love.graphics.newImage("assets/bg.png")
  that.backgroundFullWidth = 2400
  that.backgroundWidth = 800
  that.backgroundX = 0

  that.verticalLimitTop = 280
  that.verticalLimitBottom = love.graphics.getHeight()

  that.playerStartX = 50
  that.playerStartY = 300
  that.player = nil

  self.__index = self
  return setmetatable(that, self)
end

function Stage:start()
  self.player = Player:new(self)
end

function Stage:update(dt, Keys)
  self.player:update(dt, Keys)
end

function Stage:draw()
  love.graphics.draw(self.backgroundImage, self.backgroundX, 0)
  self.player:draw()
end

return Stage