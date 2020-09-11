Player = require('src/player')
Enemy = require('src/enemy')

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

  that.enemies = {}

  self.__index = self
  return setmetatable(that, self)
end

function Stage:start()
  self.player = Player:new(self)
  table.insert(self.enemies, Enemy:new(self, 400, 300))
  table.insert(self.enemies, Enemy:new(self, 900, 280))
end

function Stage:update(dt, Keys)
  self.player:update(dt, Keys)
  for key, enemy in pairs(self.enemies) do enemy:update(dt) end
end

function Stage:draw()
  love.graphics.draw(self.backgroundImage, self.backgroundX, 0)

  local entities = {}

  table.insert(entities, self.player)

  for key, enemy in pairs(self.enemies) do table.insert(entities, enemy) end

  -- Sort entities by Y
  table.sort(entities, function (a,b) return a.y < b.y end)

  for key, entity in pairs(entities) do
    entity:draw()
  end
end

return Stage