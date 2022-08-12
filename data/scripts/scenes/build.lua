
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
    
    setColor(255, 255, 255)
    clear(155, 155, 155)

    player:draw()

    setColor(0, 255, 0, 150)
    love.graphics.rectangle("fill", player.x - 60 - 24, player.y - 24, 48, 48)

    love.graphics.rectangle("fill", player.x + 60 - 24, player.y - 24, 48, 48)

    love.graphics.rectangle("fill", player.x - 24, player.y - 24 + 48, 48, 48)

    love.graphics.rectangle("fill", player.x - 24, player.y - 24 - 48, 48, 48)

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

function processInventorySlot(self, xOffset)

    love.graphics.rectangle("fill", xOffset - camera[1] - 32, 536 - camera[2] - 32, 64, 64)
    self.part:draw({x=xOffset, y=536})

end