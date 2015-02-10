State = {}
Players = {{}, {}}
SCREEN_WIDTH = 0
SCREEN_HEIGHT = 0
BLOCK_WIDTH = 32
BLOCK_HEIGHT = 32
DIRECTIONS = { w = true,  a = true, s = true, d = true }

function love.load()
  SCREEN_WIDTH, SCREEN_HEIGHT = love.window.getDimensions()
  State.static = true
  State.turn = 1

  local n = 0
  for i, player in ipairs(Players) do
    player.blocks = {{}}
    n = i - 1
    player.blocks[1].x = SCREEN_WIDTH / 2 - BLOCK_WIDTH
    player.blocks[1].y = (n) * (SCREEN_HEIGHT - BLOCK_HEIGHT)
    player.color = {255 * (n), 255 * (n), 255 * (n)}
  end
end

function intersect(a, b)
  return (
    a.x < b.x + BLOCK_WIDTH and
    a.x + BLOCK_WIDTH > b.x and
    a.y < b.y + BLOCK_HEIGHT and
    a.y + BLOCK_HEIGHT > b.y
  )
end

function outOfBounds(block)
  return block.x < 0 or block.x + BLOCK_WIDTH > SCREEN_WIDTH or block.y < 0 or block.y + BLOCK_HEIGHT > SCREEN_HEIGHT
end

function love.update(dt)
  local player = Players[State.turn]
  local enemy = Players[(State.turn % 2) + 1]
  local lastBlock = player.blocks[#player.blocks]

  for _, block in ipairs(enemy.blocks) do
    if intersect(lastBlock, block) then
      player.blocks[#player.blocks] = nil
      return
    end
  end

  if outOfBounds(lastBlock) then
    player.blocks[#player.blocks] = nil
    return
  end
end

function love.draw()
  love.graphics.setBackgroundColor(255, 0, 0)
  for _, player in ipairs(Players) do
    love.graphics.setColor(player.color)
    for _, block in ipairs(player.blocks) do
      love.graphics.rectangle("fill", block.x, block.y, BLOCK_WIDTH, BLOCK_HEIGHT)
    end
  end

  local player = Players[State.turn]
  local lastBlock = player.blocks[#player.blocks]
  love.graphics.setColor(255, 255, 0)
  love.graphics.rectangle("line", lastBlock.x, lastBlock.y, BLOCK_WIDTH, BLOCK_HEIGHT)
end

function love.keypressed(key)
  if key == "q" then
    love.event.quit()
  elseif DIRECTIONS[key] then
    local player = Players[State.turn]
    local lastBlock = player.blocks[#player.blocks]

    if key == "a" then
      table.insert(player.blocks, {x=lastBlock.x - BLOCK_WIDTH, y=lastBlock.y})
    elseif key == "d" then
      table.insert(player.blocks, {x=lastBlock.x + BLOCK_WIDTH, y=lastBlock.y})
    elseif key == "w" then
      table.insert(player.blocks, {x=lastBlock.x, y=lastBlock.y - BLOCK_HEIGHT})
    elseif key == "s" then
      table.insert(player.blocks, {x=lastBlock.x, y=lastBlock.y + BLOCK_HEIGHT})
    end

    State.turn = (State.turn % 2) + 1
  end
end
