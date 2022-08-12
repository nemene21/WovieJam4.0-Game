
function gameReload()

    player = newRobot(400, 300, function()
    
        
    
    end)

    player.
    
end

function gameDie()
    
end

function game()
    -- Reset
    sceneAt = "game"
    
    setColor(255, 255, 255)
    clear(155, 155, 155)

    player:process()
    player:draw()

    -- Return scene
    return sceneAt
end