-- cardsload.lua 
-- file for preloading card assets

CardsLoad = {}

function CardsLoad:loadCards()
    local suits = {"clubs", "diamonds", "hearts", "spades"}
    local values = {"A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"}

    self.cards = {}

    for _, suit in ipairs(suits) do
        for _, value in ipairs(values) do
            local cardName = "assets/card_"..suit.."_"..value..".png"
            self.cards[cardName] = love.graphics.newImage(cardName)
        end
    end

    self.cards["back"] = love.graphics.newImage("assets/card_back.png")
end

return CardsLoad
