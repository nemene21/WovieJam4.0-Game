
function endscreenReload()

    AGAIN = newButton(400, 300, "AGAIN")
    MENU = newButton(400, 400, "MENU")
    QUIT = newButton(400, 500, "QUIT")

    SMALL_COG = love.graphics.newImage("data/graphics/images/smallCog.png")
    BIG_COG = love.graphics.newImage("data/graphics/images/bigCog.png")

    cogRot = 0
    cogRotLerpTo = 0
    cogRotIncreaseTimer = 1

    BG1 = love.graphics.newImage("data/graphics/images/people1.png")
    BG2 = love.graphics.newImage("data/graphics/images/people2.png")
    BG3 = love.graphics.newImage("data/graphics/images/people3.png")

    playTrack("menu", 0.8)

end

function endscreenDie()

end

function endscreen()
    -- Reset
    sceneAt = "endscreen"
    
    setColor(255, 255, 255)
    clear(139, 155, 180)

    drawSprite(BG1, 400, 300 + math.sin(globalTimer * 4) * 16)
    drawSprite(BG2, 400, 400 + math.sin(globalTimer * 4 + 0.5) * 16)
    drawSprite(BG3, 400, 500 + math.sin(globalTimer * 4 + 1) * 16)

    outlinedText(400, 80, 4, "GAME OVER", {255, 255, 255}, 3, 3)

    if score == 1 then outlinedText(400, 132, 2, score .. " bot slain!", {255, 255, 255}) else outlinedText(400, 132, 2, score .. " bots slain!", {255, 255, 255}) end

    cogRotIncreaseTimer = cogRotIncreaseTimer + dt

    if cogRotIncreaseTimer > 1 then

        cogRotIncreaseTimer = 0

        cogRotLerpTo = cogRotLerpTo + 1

    end

    cogRot = lerp(cogRot, cogRotLerpTo, dt * 10)

    if AGAIN:process() then

        player = nil
        opponent = nil
        enemyParts = nil
        
        sceneAt = "build"

    end

    if MENU:process() then sceneAt = "menu" end

    if QUIT:process() then love.event.quit() end

    drawSprite(BIG_COG, 0, 600, 2, 2, cogRot)
    drawSprite(SMALL_COG, 800, 600, 2, 2, cogRot)
    drawSprite(SMALL_COG, 0, 0, 2, 2, cogRot)
    drawSprite(SMALL_COG, 800, 0, 2, 2, cogRot)

    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(MOUSE,xM,yM,0,SPRSCL * mouseScale,SPRSCL * mouseScale)

    -- Return scene
    return sceneAt
end