-- Andrea Morales Villegas
-- CMPM 121 - Project 1: Solitaire
-- 04/25/2025

-- file: main.lua

io.stdout:setvbuf("no")

Card = {}

function Card:new(suit, value)
    local newCard = {
        suit = suit,
        value = value,
        img = love.graphics.newImage("assets/card_"..suit.."_"..value..".png"),
        faceUp = false,
        x = 0,
        y = 0,
        width = 64,
        height = 64,
        dragging = false,
        offsetX = 0,
        offsetY = 0,
    }
    setmetatable(newCard, self)
    self.__index = self
    return newCard
end

function Card:draw()
    if self.faceUp then
        love.graphics.draw(self.img, self.x, self.y)
    else
        local back = love.graphics.newImage("assets/card_back.png")
        love.graphics.draw(back, self.x, self.y)
    end
end

function Card:isHovered(mx, my)
    return mx >= self.x and mx <= self.x + self.width
       and my >= self.y and my <= self.y + self.height
end

return Card

