Util = require('util')
Player = require('src/player')

function love.load()
  love.keyboard.setKeyRepeat(true)
  love.graphics.setBackgroundColor(255 / 255, 255 / 255, 237 / 255, 1)

  love.graphics.setColor(0, 0, 0, 1)

  BackgroundImage = love.graphics.newImage("assets/bg.png")

  Player = Player:new(200, 150)

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
  love.graphics.draw(BackgroundImage, 0, 0)

  Player:draw()

  love.graphics.rectangle('line', Player.x, Player.y, Player.imageWidth, Player.imageHeight)

  love.graphics.print('PositionX: ' .. Player.x, 0, 0)
  love.graphics.print('PositionY: ' .. Player.y, 0, 15)
  love.graphics.print('punchDelay: ' .. Player.punchDelay, 0, 30)
end
