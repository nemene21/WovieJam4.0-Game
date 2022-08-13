
function buildReload()

    if player == nil then

        player = newRobot(400, 300, 0, function(self)
    
            self.rotationVel = lerp(self.rotationVel, (boolToInt(pressed("d")) - boolToInt(pressed("a"))) * 360, dt * 4)
    
            self.tryingToMove = boolToInt(pressed("w")) - boolToInt(pressed("s"))
        
        end)

    end

    partInventory = {newInventorySlot("wheel"), newInventorySlot("spike")}
    partChosen = nil
    
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

    drawSprite(SLOT_IMAGE, player.x - 80, player.y)

    drawSprite(SLOT_IMAGE, player.x + 80, player.y)

    drawSprite(SLOT_IMAGE, player.x, player.y + 40)

    drawSprite(SLOT_IMAGE, player.x, player.y - 40)

    for id, slot in ipairs(partInventory) do

        local slotX = (id - 1) * 80 + 64

        slot.part.offset = {x=0,y=0}

        slot:process(slotX)

        if xM > slotX - 32 and xM < slotX + 32 and yM > 536 - 32 and yM < 536 + 32 then

            if mouseJustPressed(1) then

                partChosen = deepcopyTable(slot.part)

            end

        end

    end

    if partChosen ~= nil then

        partChosen:draw({x=xM,y=yM})

        if xM > player.x - 80 - 36 and xM < player.x - 80 + 36 and yM > player.y - 36 and yM < player.y + 36 then

            if mouseJustPressed(1) then

                player.leftPart = newPart(partChosen.name, "left")
                partChosen = nil

            end

        else

        if xM > player.x + 80 - 36 and xM < player.x + 80 + 36 and yM > player.y - 36 and yM < player.y + 36 then

            if mouseJustPressed(1) then

                player.rightPart = newPart(partChosen.name, "right")
                partChosen = nil

            end

        else

        if xM > player.x - 36 and xM < player.x + 36 and yM > player.y - 40 - 36 and yM < player.y - 40 + 36 then

            if mouseJustPressed(1) then

                player.upPart = newPart(partChosen.name, "up")
                partChosen = nil

            end

        else

        if xM > player.x - 36 and xM < player.x + 36 and yM > player.y + 40 - 36 and yM < player.y + 40 + 36 then

            if mouseJustPressed(1) then

                player.downPart = newPart(partChosen.name, "down")
                partChosen = nil

            end

        end end end end

    end

    -- Return scene
    return sceneAt
end

function newInventorySlot(part)

    return {

        part = newPart(part),
        process = processInventorySlot

    }

end

SLOT_IMAGE = love.graphics.newImage("data/graphics/images/slotIcon.png")

function processInventorySlot(self, xOffset)

    setColor(255, 255, 255)
    drawSprite(SLOT_IMAGE, xOffset, 536)
    self.part:draw({x=xOffset, y=536})

end