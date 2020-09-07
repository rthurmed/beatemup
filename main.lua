Util = require('util')

SCALE_FACTOR = 40

function love.load()
  love.keyboard.setKeyRepeat(true)

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
  if key == 'escape' then
    love.event.quit()
    return
  end
  Keys[key] = nil
end

function love.update(dt)
  local originalX = PositionX
  local originalY = PositionY

  for key, value in pairs(Keys) do
    if value == true then
      if key == 'up' then
        PositionY = PositionY - MoveSpeed
      elseif key == 'down' then
        PositionY = PositionY + MoveSpeed
      elseif key == 'left' then
        PositionX = PositionX - MoveSpeed
      elseif key == 'right' then
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
    love.graphics.draw(Animation.spriteSheet, Animation.quads[spriteNum], PositionX, PositionY, 0, PositionY / SCALE_FACTOR)
  else
    love.graphics.draw(Standing, PositionX, PositionY, 0, PositionY / SCALE_FACTOR)
  end

  love.graphics.rectangle('line', PositionX, PositionY, 64 * PositionY / SCALE_FACTOR, 96 * PositionY / SCALE_FACTOR)

  love.graphics.print('PositionX: ' .. PositionX, 0, 0)
  love.graphics.print('PositionY: ' .. PositionY, 0, 15)
  love.graphics.print('RealY: ' .. PositionY * PositionY / SCALE_FACTOR, 0, 30)
end
