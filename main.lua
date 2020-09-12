Util = require('util')
Stage = require('src/stage')

DEBUG = os.getenv("DEBUG") or false

function love.load()
  love.keyboard.setKeyRepeat(true)
  love.graphics.setBackgroundColor(255 / 255, 255 / 255, 237 / 255, 1)

  Stage = Stage:new()
  Stage:start()

  -- https://opengameart.org/content/a-cloudy-morning-jazz
  -- Author: https://matthewpablo.com/
  Music = love.audio.newSource('assets/soundtrack.mp3', 'stream')
  Music:setVolume(0.3)
  Music:play()

  PunchHit = love.audio.newSource('assets/hit.flac', 'static')

  HeartImage = love.graphics.newImage("assets/heart.png")

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

  if Stage.player.life <= 0 then
    love.graphics.setColor(1, 0, 0)
    if Music:isPlaying() then
      Music:stop()
    end
  end
end

function love.draw()
  Stage:draw()

  if DEBUG then
    love.graphics.print('PositionX: ' .. Stage.player.x, 0, 0)
    love.graphics.print('PositionY: ' .. Stage.player.y, 0, 15)
    love.graphics.print('punchDelay: ' .. Stage.player.punchDelay, 0, 30)
    love.graphics.print('Stage.backgroundX: ' .. Stage.backgroundX, 0, 45)
    love.graphics.print('LIFE: ' .. Stage.player.life, 0, 60)

    if Stage.player.damagebox ~= nil then
      love.graphics.print('HIT: ' .. (Stage.player.damagebox:isTouching(Stage.enemies[1]:getHitbox()) and 'YES' or 'NO'), 0, 75)
    end
  end
end
