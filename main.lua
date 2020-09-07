Util = require('util')

function love.load()
  love.physics.setMeter(32)
  love.keyboard.setKeyRepeat(true)
  World = love.physics.newWorld(0, 9.81*32, true)

  Animation = Util.newAnimation(love.graphics.newImage("assets/dog-run.png"), 64, 96, 1 / 3)
  Standing = love.graphics.newImage("assets/dog-stand.png")
  PositionX = 400
  PositionY = 300
  MoveSpeed = 4

  Keys = {}
  IsWalking = false
end

function love.keypressed(key)
  Keys[key] = true
end

function love.keyreleased(key)
  if key == "escape" then
    love.event.quit()
    return
  end
  Keys[key] = nil
end

function love.update(dt)
  World:update(dt)

  local originalX = PositionX
  local originalY = PositionY

  for key, value in pairs(Keys) do
    if value == true then
      if key == "up" then
        PositionY = PositionY - MoveSpeed
      elseif key == "down" then
        PositionY = PositionY + MoveSpeed
      elseif key == "left" then
        PositionX = PositionX - MoveSpeed
      elseif key == "right" then
        PositionX = PositionX + MoveSpeed
      end
    end
  end

  IsWalking = originalX ~= PositionX or originalY ~= PositionY

  Animation.currentTime = Animation.currentTime + dt
  if Animation.currentTime >= Animation.duration then
      Animation.currentTime = Animation.currentTime - Animation.duration
  end
end

function love.draw()
  if IsWalking then
    local spriteNum = math.floor(Animation.currentTime / Animation.duration * #Animation.quads) + 1
    love.graphics.draw(Animation.spriteSheet, Animation.quads[spriteNum], PositionX, PositionY, 0, PositionY / 30)
  else
    love.graphics.draw(Standing, PositionX, PositionY, 0, PositionY / 30)
  end
end
