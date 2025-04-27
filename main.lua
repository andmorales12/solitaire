-- Andrea Morales Villegas
-- CMPM 121 - Project 1: Solitaire
-- 04/25/2025

-- file: main.lua

io.stdout:setvbuf("no")

local CardsLoad = require "cardsload"
local CardPiles = require "cardpiles"
local Controls = require "controls"

local cardPiles
local controls

function love.load()
    love.graphics.setBackgroundColor(0, 0.5, 0) -- load game background color

    cardPiles = CardPiles:new()
    cardPiles:init()

    controls = Controls:new(cardPiles)
end

function love.update(dt)
    -- for movement
    controls:update(dt)
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
