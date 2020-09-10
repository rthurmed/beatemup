Util = require('util')
Player = require('src/player')

SCALE_FACTOR = 40

function love.load()
  love.keyboard.setKeyRepeat(true)

  Player = Player:new(200, 150, SCALE_FACTOR)

  Keys = {}
end

function love.keypressed(key)
  Keys[key] = true
end

function love.keyreleased(key)
  if key == 'escape' then
    love.event.quit()
    return
  end
  Keys[key] = nil
end

function love.update(dt)
  Player:update(dt, Keys)
end

function love.draw()
  Player:draw()

  love.graphics.rectangle('line', Player.x, Player.y, Player:getEndX(), Player:getEndY())

  love.graphics.print('PositionX: ' .. Player.x, 0, 0)
  love.graphics.print('PositionY: ' .. Player.y, 0, 15)
  love.graphics.print('punchDelay: ' .. Player.punchDelay, 0, 30)
end
