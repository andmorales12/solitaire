-- controls.lua 
-- this file will deal with user input control (movement)

Controls = {}

function Controls:new(piles)
    local obj = {
        piles = piles,
        draggedCard = nil,
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Controls:mousepressed(x, y, button)
    if button == 1 then -- Left click

        -- First check deck click
        if x > self.piles.deckX and x < self.piles.deckX + 64
        and y > self.piles.deckY and y < self.piles.deckY + 64 then
            self.piles:drawFromDeck()
            return
        end

        -- Then check draw pile (top card)
        if #self.piles.drawPile > 0 then
            local topCard = self.piles.drawPile[#self.piles.drawPile]
            if topCard:isHovered(x, y) then
                self.draggedCard = topCard
                self.draggedCard.dragging = true
                self.draggedCard.offsetX = x - self.draggedCard.x
                self.draggedCard.offsetY = y - self.draggedCard.y
                return
            end
        end

        -- Then check tableau cards (only face up)
        for _, pile in ipairs(self.piles.tableau) do
            for i = #pile, 1, -1 do
                local card = pile[i]
                if card.faceUp and card:isHovered(x, y) then
                    self.draggedCard = card
                    self.draggedCard.dragging = true
                    self.draggedCard.offsetX = x - card.x
                    self.draggedCard.offsetY = y - card.y
                    return
                end
            end
        end
    end
end

function Controls:mousereleased(x, y, button)
    if button == 1 then
        if self.draggedCard then
            self.draggedCard.dragging = false
            self.draggedCard = nil
        end
    end
end

function Controls:update(dt)
    local mx, my = love.mouse.getPosition()

    if self.draggedCard and self.draggedCard.dragging then
        self.draggedCard.x = mx - self.draggedCard.offsetX
        self.draggedCard.y = my - self.draggedCard.offsetY
    end
end

return Controls
