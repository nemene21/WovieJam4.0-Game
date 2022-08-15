
function buildReload()

    if player == nil then

        player = newRobot(400, 300, 0, function(self)
            
            if not overdrive then

                self.rotationVel = lerp(self.rotationVel, (boolToInt(pressed("d")) - boolToInt(pressed("a"))) * 360, dt * 4)

                self.tryingToMove = boolToInt(pressed("w")) - boolToInt(pressed("s"))

            else

                self.rotationVel = lerp(self.rotationVel, 720, dt * 8)

                self.tryingToMove = 4

            end
        
        end)

        partInventory = {newInventorySlot("wheel", 0), newInventorySlot("wheel", 0), newInventorySlot("spike", 0), newInventorySlot("TNT", 0)}

        score = 0

    else

        player.rotation = 0

        player.x = 400; player.y = 300

        if player.leftPart ~= nil then player.leftPart = newPart(player.leftPart.name, "left", player.leftPart.tier) end

        if player.rightPart ~= nil then player.rightPart = newPart(player.rightPart.name, "right", player.rightPart.tier) end

        if player.upPart ~= nil then player.upPart = newPart(player.upPart.name, "up", player.upPart.tier) end

        if player.downPart ~= nil then player.downPart = newPart(player.downPart.name, "down", player.downPart.tier) end

        table.insert(partInventory, newInventorySlot(parts[love.math.random(1, #parts)], love.math.random(0, 3)))

    end

    partChosen = nil

    placeLostScale1 = 1
    placeLostScale2 = 1
    placeLostScale3 = 1
    placeLostScale4 = 1

    inventorySlotPlus = {scale = 1}

    BG = love.graphics.newImage("data/graphics/images/blueprint.png")

    scrollVel = 0
    scrollParts = 0

    trashSlotScale = 1

    DONE = newButton(400, 150, "DONE")

    TRASH = love.graphics.newImage("data/graphics/images/trashIcon.png")
    
end

function buildDie()
    
end

function build()
    -- Reset
    sceneAt = "build"
    
    setColor(100, 100, 100)
    drawSprite(BG, 400, 300)

    if DONE:process() then
        
        sceneAt = "game"
        
        if partChosen ~= nil then
            table.insert(partInventory, newInventorySlot(partChosen.name, partChosen.tier))

            partChosen = nil
        end
    
    end
    
    scrollVel = lerp(scrollVel, 0, dt * 6)
    scrollVel = scrollVel + getScroll() * 200

    scrollParts = scrollParts + scrollVel * dt

    scrollParts = lerp(scrollParts, clamp(scrollParts, math.min((#partInventory + 1) * - 96 + 800 - 64, 0), 0), dt * 15)

    setColor(255, 255, 255)
    player:draw()

    drawSprite(SLOT_IMAGE, player.x - 80, player.y, placeLostScale1, placeLostScale1)

    drawSprite(SLOT_IMAGE, player.x + 80, player.y, placeLostScale2, placeLostScale2)

    drawSprite(SLOT_IMAGE, player.x, player.y - 40, placeLostScale3, placeLostScale3)

    drawSprite(SLOT_IMAGE, player.x, player.y + 40, placeLostScale4, placeLostScale4)

    local alreadyPressed = false

    local kill = {}
    for id, slot in ipairs(partInventory) do

        local slotX = (id - 1) * 96 + 64 + scrollParts

        if slot.part ~= nil then slot.part.offset = {x=0,y=0} end

        slot:process(slotX)

        if xM > slotX - 36 and xM < slotX + 36 and yM > 536 - 36 and yM < 536 + 36 and slot.part ~= nil and not alreadyPressed then

            slot.scale = lerp(slot.scale, 1.2, dt * 12)

            if mouseJustPressed(1) and partChosen == nil then

                alreadyPressed = true

                partChosen = deepcopyTable(slot.part)
                slot.scale = 1.45

                slot.part = nil

                table.insert(kill, id)

            end

        else

            slot.scale = lerp(slot.scale, 1, dt * 12)

        end

    end partInventory = wipeKill(kill, partInventory)

    local slotX = #partInventory * 96 + 64 + scrollParts -- Slot to return items

    setColor(255, 255, 255)
    drawSprite(SLOT_IMAGE, slotX, 536, inventorySlotPlus.scale, inventorySlotPlus.scale)

    if xM > slotX - 36 and xM < slotX + 36 and yM > 536 - 36 and yM < 536 + 36 and not alreadyPressed then

        inventorySlotPlus.scale = lerp(inventorySlotPlus.scale, 1.2, dt * 12)

        if mouseJustPressed(1) then

            inventorySlotPlus.scale = 1.45

            if partChosen ~= nil then

                table.insert(partInventory, newInventorySlot(partChosen.name, partChosen.tier))

                partChosen = nil

            end

        end

    else

        inventorySlotPlus.scale = lerp(inventorySlotPlus.scale, 1, dt * 12)

    end

    -- Slot to trash items

    setColor(255, 255, 255)
    drawSprite(SLOT_IMAGE, 64, 64, trashSlotScale, trashSlotScale)
    drawSprite(TRASH, 64, 64)

    if xM > 64 - 36 and xM < 64 + 36 and yM > 64 - 36 and yM < 64 + 36 and not alreadyPressed then

        trashSlotScale = lerp(trashSlotScale, 1.2, dt * 12)

        if mouseJustPressed(1) then

            trashSlotScale = 1.45

            partChosen = nil

        end

    else

        trashSlotScale = lerp(trashSlotScale, 1, dt * 12)

    end

    for id, slot in ipairs(partInventory) do

        local slotX = (id - 1) * 96 + 64 + scrollParts

        if xM > slotX - 36 and xM < slotX + 36 and yM > 536 - 36 and yM < 536 + 36 and slot.part ~= nil and not alreadyPressed then

            drawPartToolTip(slot.part)

        end

    end

    if partChosen ~= nil then

        partChosen.offset = {x=0,y=0}
        partChosen:draw({x=xM,y=yM})

    end

    if xM > player.x - 80 - 36 and xM < player.x - 80 + 36 and yM > player.y - 36 and yM < player.y + 36 then

        placeLostScale1 = lerp(placeLostScale1, 1.2, dt * 12)

        if player.leftPart ~= nil then drawPartToolTip(player.leftPart) end

        if mouseJustPressed(1) then

            local playerPartHold = deepcopyTable(player.leftPart)

            if partChosen ~= nil then player.leftPart = newPart(partChosen.name, "left", partChosen.tier) else player.leftPart = nil end
            partChosen = playerPartHold

            placeLostScale1 = 1.45

        end

    else

        placeLostScale1 = lerp(placeLostScale1, 1, dt * 12)

    end

    if xM > player.x + 80 - 36 and xM < player.x + 80 + 36 and yM > player.y - 36 and yM < player.y + 36 then -- Is over the place buttons?

        placeLostScale2 = lerp(placeLostScale2, 1.2, dt * 12)

        if player.rightPart ~= nil then drawPartToolTip(player.rightPart) end

        if mouseJustPressed(1) then

            local playerPartHold = deepcopyTable(player.rightPart)

            if partChosen ~= nil then player.rightPart = newPart(partChosen.name, "right", partChosen.tier) else player.rightPart = nil end
            partChosen = playerPartHold

            placeLostScale2 = 1.45

        end

    else

        placeLostScale2 = lerp(placeLostScale2, 1, dt * 12)

    end

    if xM > player.x - 36 and xM < player.x + 36 and yM > player.y - 40 - 36 and yM < player.y - 40 + 36 then

        placeLostScale3 = lerp(placeLostScale3, 1.2, dt * 12)

        if player.upPart ~= nil then drawPartToolTip(player.upPart) end

        if mouseJustPressed(1) then

            local playerPartHold = deepcopyTable(player.upPart)

            if partChosen ~= nil then player.upPart = newPart(partChosen.name, "up", partChosen.tier) else player.upPart = nil end
            partChosen = playerPartHold

            placeLostScale3 = 1.45

        end

    else

        placeLostScale3 = lerp(placeLostScale3, 1, dt * 12)

    end

    if xM > player.x - 36 and xM < player.x + 36 and yM > player.y + 40 - 36 and yM < player.y + 40 + 36 then

        placeLostScale4 = lerp(placeLostScale4, 1.2, dt * 12)

        if player.downPart ~= nil then drawPartToolTip(player.downPart) end

        if mouseJustPressed(1) then

            local playerPartHold = deepcopyTable(player.downPart)

            if partChosen ~= nil then player.downPart = newPart(partChosen.name, "down", partChosen.tier) else player.downPart = nil end
            partChosen = playerPartHold

            placeLostScale4 = 1.45

        end

    else

        placeLostScale4 = lerp(placeLostScale4, 1, dt * 12)

    end

    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(MOUSE,xM,yM,0,SPRSCL * mouseScale,SPRSCL * mouseScale)

    -- Return scene
    return sceneAt
end

function newInventorySlot(part, tier)

    return {

        part = newPart(part, nil, tier),
        process = processInventorySlot,

        scale = 1

    }

end

SLOT_IMAGE = love.graphics.newImage("data/graphics/images/slotIcon.png")

function processInventorySlot(self, xOffset)

    setColor(255, 255, 255)
    drawSprite(SLOT_IMAGE, xOffset, 536, self.scale, self.scale)
    if self.part ~= nil then self.part:draw({x=xOffset, y=536}) end

end