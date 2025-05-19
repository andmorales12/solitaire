-- controls.lua 
-- this file will deal with user input control (movement)

Controls = {}

function Controls:new(piles)
    local obj = {
        piles = piles,
        draggedCard = nil,
        draggedStack = nil,
        originalPile = nil,
        offsetX = 0,
        offsetY = 0
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

        -- Then check draw pile (top card only)
        local drawPile = self.piles.drawPile
        if #drawPile > 0 then
            local topCard = drawPile[#drawPile]
            if topCard:isHovered(x, y) then
                self.draggedCard = topCard
                self.originalPile = drawPile
                self.offsetX = x - topCard.x
                self.offsetY = y - topCard.y
                return
            end
        end

        -- Check tableau for a face-up card to drag (single card or stack)
        for i, pile in ipairs(self.piles.tableau) do
            for j = #pile, 1, -1 do
                local card = pile[j]
                if card.faceUp and card:isHovered(x, y) then
                    self.originalPile = pile
                    self.draggedStack = {}
                    for k = j, #pile do
                        table.insert(self.draggedStack, pile[k])
                    end
                    for k = #pile, j, -1 do
                        table.remove(pile, k)
                    end
                    self.offsetX = x - card.x
                    self.offsetY = y - card.y
                    return
                end
            end
        end
    end
end

function Controls:mousereleased(x, y, button)
    if button == 1 then
        if self.draggedCard then
            local placed = false

            -- Try to place card in foundations
            for _, pile in ipairs(self.piles.foundations) do
                if self:isValidFoundationDrop(self.draggedCard, pile, x, y) then
                    table.insert(pile, self.draggedCard)
                    self:removeFromOriginal(self.draggedCard)
                    placed = true
                    break
                end
            end

            -- Try to place card in tableau
            if not placed then
                for _, pile in ipairs(self.piles.tableau) do
                    if self:isValidTableauDrop(self.draggedCard, pile, x, y) then
                        table.insert(pile, self.draggedCard)
                        self:removeFromOriginal(self.draggedCard)
                        placed = true
                        break
                    end
                end
            end

            -- If not placed, return to original position
            if not placed and self.originalPile then
                table.insert(self.originalPile, self.draggedCard)
            end

            self.draggedCard.dragging = false
            self.draggedCard = nil
            self.originalPile = nil
        end

        if self.draggedStack then
            local stackTop = self.draggedStack[1]
            local placed = false

            -- Try to place stack in tableau
            for _, pile in ipairs(self.piles.tableau) do
                if self:isValidTableauDrop(stackTop, pile, x, y) then
                    for _, card in ipairs(self.draggedStack) do
                        table.insert(pile, card)
                    end
                    placed = true
                    break
                end
            end

            -- If not placed, return to original pile
            if not placed and self.originalPile then
                for _, card in ipairs(self.draggedStack) do
                    table.insert(self.originalPile, card)
                end
            end

            self.draggedStack = nil
            self.originalPile = nil
        end
    end
end

function Controls:update(dt)
    local mx, my = love.mouse.getPosition()

    if self.draggedCard then
        self.draggedCard.x = mx - self.offsetX
        self.draggedCard.y = my - self.offsetY
    elseif self.draggedStack then
        for i, card in ipairs(self.draggedStack) do
            card.x = mx - self.offsetX
            card.y = my - self.offsetY + (i - 1) * 30
        end
    end
end

function Controls:removeFromOriginal(card)
    for i = #self.originalPile, 1, -1 do
        if self.originalPile[i] == card then
            table.remove(self.originalPile, i)
            break
        end
    end
end

function Controls:isValidFoundationDrop(card, pile, x, y)
    local pileX = 400 + ((self:getFoundationIndex(pile) - 1) * 80)
    local pileY = 100
    if x >= pileX and x <= pileX + 64 and y >= pileY and y <= pileY + 64 then
        if #pile == 0 then
            return card.value == "A"
        else
            local top = pile[#pile]
            return card.suit == top.suit and self:getValueIndex(card.value) == self:getValueIndex(top.value) + 1
        end
    end
    return false
end

function Controls:isValidTableauDrop(card, pile, x, y)
    local pileX = 100 + ((self:getTableauIndex(pile) - 1) * 80)
    local pileY = 300 + (#pile * 30)
    if x >= pileX and x <= pileX + 64 and y >= pileY - 30 and y <= pileY + 64 then
        if #pile == 0 then
            return card.value == "K"
        else
            local top = pile[#pile]
            return self:isOppositeColor(card.suit, top.suit) and self:getValueIndex(card.value) == self:getValueIndex(top.value) - 1
        end
    end
    return false
end

function Controls:getFoundationIndex(pile)
    for i, p in ipairs(self.piles.foundations) do
        if p == pile then return i end
    end
    return 1
end

function Controls:getTableauIndex(pile)
    for i, p in ipairs(self.piles.tableau) do
        if p == pile then return i end
    end
    return 1
end

function Controls:getValueIndex(val)
    local order = {A=1, ["2"]=2, ["3"]=3, ["4"]=4, ["5"]=5, ["6"]=6, ["7"]=7, ["8"]=8, ["9"]=9, ["10"]=10, J=11, Q=12, K=13}
    return order[val] or 0
end

function Controls:isOppositeColor(suit1, suit2)
    local red = {hearts=true, diamonds=true}
    local black = {spades=true, clubs=true}
    return (red[suit1] and black[suit2]) or (black[suit1] and red[suit2])
end

return Controls

