-- cardpiles.lua 
-- this file will contain the drawing of the tableau, the foundations, deck, and the draw pile

local Card = require "card"

CardPiles = {}

function CardPiles:new()
    local obj = {
        deck = {},
        drawPile = {},
        tableau = { {}, {}, {}, {}, {}, {}, {} },
        foundations = { {}, {}, {}, {} },
        deckX = 100,
        deckY = 100,
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function CardPiles:init()
    self:initializeDeck()
end

function CardPiles:initializeDeck()
    local suits = {"clubs", "diamonds", "hearts", "spades"}
    local values = {"A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"}

    for _, suit in ipairs(suits) do
        for _, value in ipairs(values) do
            local card = Card:new(suit, value)
            table.insert(self.deck, card)
        end
    end

    self:shuffleDeck()
    self:dealCards()
end

function CardPiles:shuffleDeck()
    for i = #self.deck, 2, -1 do
        local j = math.random(i)
        self.deck[i], self.deck[j] = self.deck[j], self.deck[i]
    end
end

function CardPiles:dealCards()
    local cardIndex = 1
    for i = 1, 7 do
        for j = 1, i do
            local card = self.deck[cardIndex]
            card.x = 100 + (i - 1) * 80
            card.y = 300 + (j - 1) * 30
            card.faceUp = (j == i)
            table.insert(self.tableau[i], card)
            cardIndex = cardIndex + 1
        end
    end

    -- Remove dealt cards from the deck
    for i = 1, cardIndex - 1 do
        table.remove(self.deck, 1)
    end
end

function CardPiles:drawFromDeck()
    if #self.deck > 0 then
        local card = table.remove(self.deck)
        card.faceUp = true
        card.x = 200
        card.y = 100
        table.insert(self.drawPile, card)
    elseif #self.drawPile > 0 then
        -- Reset draw pile into deck
        while #self.drawPile > 0 do
            local card = table.remove(self.drawPile)
            card.faceUp = false
            table.insert(self.deck, 1, card)
        end
    end
end

function CardPiles:draw()
    love.graphics.setColor(1, 1, 1)

    -- Draw deck
    love.graphics.rectangle("line", self.deckX, self.deckY, 64, 64)
    if #self.deck > 0 then
        local back = love.graphics.newImage("assets/card_back.png")
        love.graphics.draw(back, self.deckX, self.deckY)
    end

    -- draw draw pile
    love.graphics.rectangle("line", 200, 100, 64, 64)
    if #self.drawPile > 0 then
        local topCard = self.drawPile[#self.drawPile]
        topCard:draw()
    end

    -- draw the tableau
    for i, pile in ipairs(self.tableau) do
        for j, card in ipairs(pile) do
            card:draw()
        end
    end

    -- draw foundations
    for i = 1, 4 do
        love.graphics.rectangle("line", 400 + (i - 1) * 80, 100, 64, 64)
    end
end

return CardPiles
