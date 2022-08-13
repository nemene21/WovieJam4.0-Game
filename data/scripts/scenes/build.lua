
function buildReload()

    if player == nil then

        player = newRobot(400, 300, 0, function(self)
    
            self.rotationVel = lerp(self.rotationVel, (boolToInt(pressed("d")) - boolToInt(pressed("a"))) * 360, dt * 4)
    
            self.tryingToMove = boolToInt(pressed("w")) - boolToInt(pressed("s"))
        
        end)

    end

    partInventory = {newInventorySlot("wheel"), newInventorySlot("spike"), newInventorySlot("rocketEngine"), newInventorySlot("gun")}
    partChosen = nil

    placeLostScale1 = 1
    placeLostScale2 = 1
    placeLostScale3 = 1
    placeLostScale4 = 1
    
end

function buildDie()
    
end

function build()
    -- Reset
    sceneAt = "build"

    if pressed("space") then sceneAt = "game" end
    
    setColor(255, 255, 255)
    clear(155, 155, 155)

    setColor(255, 255, 255)
    player:draw()

    drawSprite(SLOT_IMAGE, player.x - 80, player.y, placeLostScale1, placeLostScale1)

    drawSprite(SLOT_IMAGE, player.x + 80, player.y, placeLostScale2, placeLostScale2)

    drawSprite(SLOT_IMAGE, player.x, player.y - 40, placeLostScale3, placeLostScale3)

    drawSprite(SLOT_IMAGE, player.x, player.y + 40, placeLostScale4, placeLostScale4)

    for id, slot in ipairs(partInventory) do

        local slotX = (id - 1) * 96 + 64

        slot.part.offset = {x=0,y=0}

        slot:process(slotX)

        if xM > slotX - 36 and xM < slotX + 36 and yM > 536 - 36 and yM < 536 + 36 then

            slot.scale = lerp(slot.scale, 1.2, dt * 12)

            if mouseJustPressed(1) then

                partChosen = deepcopyTable(slot.part)
                slot.scale = 1.45

            end

        else

            slot.scale = lerp(slot.scale, 1, dt * 12)

        end

    end

    if partChosen ~= nil then

        partChosen.offset = {x=0,y=0}
        partChosen:draw({x=xM,y=yM})

    end

    if xM > player.x - 80 - 36 and xM < player.x - 80 + 36 and yM > player.y - 36 and yM < player.y + 36 then

        placeLostScale1 = lerp(placeLostScale1, 1.2, dt * 12)

        if mouseJustPressed(1) then

            local playerPartHold = deepcopyTable(player.leftPart)

            if partChosen ~= nil then player.leftPart = newPart(partChosen.name, "left") else player.leftPart = nil end
            partChosen = playerPartHold

            placeLostScale1 = 1.45

        end

    else

        placeLostScale1 = lerp(placeLostScale1, 1, dt * 12)

    end

    if xM > player.x + 80 - 36 and xM < player.x + 80 + 36 and yM > player.y - 36 and yM < player.y + 36 then -- Is over the place buttons?

        placeLostScale2 = lerp(placeLostScale2, 1.2, dt * 12)

        if mouseJustPressed(1) then

            local playerPartHold = deepcopyTable(player.rightPart)

            if partChosen ~= nil then player.rightPart = newPart(partChosen.name, "right") else player.rightPart = nil end
            partChosen = playerPartHold

            placeLostScale2 = 1.45

        end

    else

        placeLostScale2 = lerp(placeLostScale2, 1, dt * 12)

    end

    if xM > player.x - 36 and xM < player.x + 36 and yM > player.y - 40 - 36 and yM < player.y - 40 + 36 then

        placeLostScale3 = lerp(placeLostScale3, 1.2, dt * 12)

        if mouseJustPressed(1) then

            local playerPartHold = deepcopyTable(player.upPart)

            if partChosen ~= nil then player.upPart = newPart(partChosen.name, "up") else player.upPart = nil end
            partChosen = playerPartHold

            placeLostScale3 = 1.45

        end

    else

        placeLostScale3 = lerp(placeLostScale3, 1, dt * 12)

    end

    if xM > player.x - 36 and xM < player.x + 36 and yM > player.y + 40 - 36 and yM < player.y + 40 + 36 then

        placeLostScale4 = lerp(placeLostScale4, 1.2, dt * 12)

        if mouseJustPressed(1) then

            local playerPartHold = deepcopyTable(player.downPart)

            if partChosen ~= nil then player.downPart = newPart(partChosen.name, "down") else player.downPart = nil end
            partChosen = playerPartHold

            placeLostScale4 = 1.45

        end

    else

        placeLostScale4 = lerp(placeLostScale4, 1, dt * 12)

    end

    -- Return scene
    return sceneAt
end

function newInventorySlot(part)

    return {

        part = newPart(part),
        process = processInventorySlot,

        scale = 1

    }

end

SLOT_IMAGE = love.graphics.newImage("data/graphics/images/slotIcon.png")

function processInventorySlot(self, xOffset)

    setColor(255, 255, 255)
    drawSprite(SLOT_IMAGE, xOffset, 536, self.scale, self.scale)
    self.part:draw({x=xOffset, y=536})

end