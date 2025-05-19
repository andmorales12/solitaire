-- card.lua
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
        originalPile = nil,
        originalIndex = nil,
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

function Card:isRed()
    return self.suit == "hearts" or self.suit == "diamonds"
end

function Card:canPlaceOn(target)
    -- For tableau: opposite color and one less in value
    local valMap = {
        A = 1, ["2"] = 2, ["3"] = 3, ["4"] = 4, ["5"] = 5, ["6"] = 6,
        ["7"] = 7, ["8"] = 8, ["9"] = 9, ["10"] = 10, J = 11, Q = 12, K = 13
    }

    if not target then return false end
    if self:isRed() ~= target:isRed() and valMap[self.value] == valMap[target.value] - 1 then
        return true
    end
    return false
end

function Card:canPlaceOnFoundation(target)
    local valMap = {
        A = 1, ["2"] = 2, ["3"] = 3, ["4"] = 4, ["5"] = 5, ["6"] = 6,
        ["7"] = 7, ["8"] = 8, ["9"] = 9, ["10"] = 10, J = 11, Q = 12, K = 13
    }

    if not target then
        return self.value == "A"
    end

    return self.suit == target.suit and valMap[self.value] == valMap[target.value] + 1
end

return Card

