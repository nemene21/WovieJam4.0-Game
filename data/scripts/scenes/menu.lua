
function menuReload()

    PLAY = newButton(400, 250, "PLAY")
    QUIT = newButton(400, 350, "QUIT")

    SMALL_COG = love.graphics.newImage("data/graphics/images/smallCog.png")
    BIG_COG = love.graphics.newImage("data/graphics/images/bigCog.png")

    cogRot = 0
    cogRotLerpTo = 0
    cogRotIncreaseTimer = 1
    
end

function menuDie()

end

function menu()
    -- Reset
    sceneAt = "menu"
    
    setColor(255, 255, 255)
    clear(155, 155, 155)

    cogRotIncreaseTimer = cogRotIncreaseTimer + dt

    if cogRotIncreaseTimer > 1 then

        cogRotIncreaseTimer = 0

        cogRotLerpTo = cogRotLerpTo + 1

    end

    cogRot = lerp(cogRot, cogRotLerpTo, dt * 10)

    if PLAY:process() then

        player = nil
        opponent = nil
        enemyParts = nil
        
        sceneAt = "build"

    end

    if QUIT:process() then love.event.quit() end

    drawSprite(BIG_COG, 0, 600, 2, 2, cogRot)
    drawSprite(SMALL_COG, 800, 600, 2, 2, cogRot)
    drawSprite(SMALL_COG, 0, 0, 2, 2, cogRot)

    -- Return scene
    return sceneAt
end