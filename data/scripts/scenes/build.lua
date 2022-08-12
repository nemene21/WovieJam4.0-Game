
function buildReload()

    if player == nil then

        player = newRobot(400, 300, 0, function(self)
    
            self.rotationVel = lerp(self.rotationVel, (boolToInt(pressed("d")) - boolToInt(pressed("a"))) * 360, dt * 4)
    
            self.tryingToMove = boolToInt(pressed("w")) - boolToInt(pressed("s"))
        
        end)

    end

    partInventory = {}
    
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

    -- Return scene
    return sceneAt
end