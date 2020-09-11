Util = require('util')
Stage = require('src/stage')

function love.load()
  love.keyboard.setKeyRepeat(true)
  love.graphics.setBackgroundColor(255 / 255, 255 / 255, 237 / 255, 1)

  love.graphics.setColor(0, 0, 0, 1)

  BackgroundImage = love.graphics.newImage("assets/bg.png")

  Stage = Stage:new()
  Stage:start()

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
  Stage:update(dt, Keys)
end

function love.draw()
  Stage:draw()

  love.graphics.print('PositionX: ' .. Stage.player.x, 0, 0)
  love.graphics.print('PositionY: ' .. Stage.player.y, 0, 15)
  love.graphics.print('punchDelay: ' .. Stage.player.punchDelay, 0, 30)
  love.graphics.print('Stage.backgroundX: ' .. Stage.backgroundX, 0, 45)
end
