-- Andrea Morales Villegas
-- CMPM 121 - Project 2: Solitaire, but better

-- file: main.lua

io.stdout:setvbuf("no")

GAME_TITLE = "Solitaire"

local CardsLoad = require "cardsload"
local CardPiles = require "cardpiles"
local Controls = require "controls"

local cardPiles
local controls
local win = false
local resetButton = { x = 700, y = 500, w = 100, h = 40 }

function love.load()
    love.window.setTitle("solitaire")
    love.graphics.setBackgroundColor(0, 0.5, 0)
    cardPiles = CardPiles:new()
    cardPiles:init()
    controls = Controls:new(cardPiles)
end

function love.update(dt)
    controls:update(dt)
    if cardPiles:checkWin() then
        win = true
    end
end

function love.draw()
    cardPiles:draw()
    if win then
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("You Win!", 0, 50, love.graphics.getWidth(), "center")
    end
    -- Draw reset button
    love.graphics.setColor(0.8, 0.1, 0.1)
    love.graphics.rectangle("fill", resetButton.x, resetButton.y, resetButton.w, resetButton.h)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Reset", resetButton.x, resetButton.y + 10, resetButton.w, "center")
end

function love.mousepressed(x, y, button, istouch, presses)
    if x > resetButton.x and x < resetButton.x + resetButton.w and y > resetButton.y and y < resetButton.y + resetButton.h then
        cardPiles:init()
        win = false
    else
        controls:mousepressed(x, y, button)
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    controls:mousereleased(x, y, button)
end

function love.draw()
    cardPiles:draw()
end

function love.mousepressed(x, y, button, istouch, presses)
    controls:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button, istouch, presses)
    controls:mousereleased(x, y, button)
end
