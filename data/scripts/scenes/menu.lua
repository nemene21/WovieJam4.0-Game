
function menuReload()

    PLAY = newButton(400, 320, "PLAY")
    QUIT = newButton(400, 400, "QUIT")

    SMALL_COG = love.graphics.newImage("data/graphics/images/smallCog.png")
    BIG_COG = love.graphics.newImage("data/graphics/images/bigCog.png")

    cogRot = 0
    cogRotLerpTo = 0
    cogRotIncreaseTimer = 1

    BG1 = love.graphics.newImage("data/graphics/images/people1.png")
    BG2 = love.graphics.newImage("data/graphics/images/people2.png")
    BG3 = love.graphics.newImage("data/graphics/images/people3.png")

    MUSIC_SLIDER = newSlider(200, 475, "Music", MUSIC_VOLUME / 0.5, 0.1, "%")
    SFX_SLIDER = newSlider(600, 475, "Sound Effects", SFX_VOLUME / 2, 0.1, "%")

    playTrack("menu", 2)

    TITLE = love.graphics.newImage("data/graphics/images/logo.png")
    
end

function menuDie()

end

function menu()
    -- Reset
    sceneAt = "menu"
    
    setColor(255, 255, 255)
    clear(139, 155, 180)

    drawSprite(BG1, 400, 300 + math.sin(globalTimer * 4) * 16)
    drawSprite(BG2, 400, 400 + math.sin(globalTimer * 4 + 0.5) * 16)
    drawSprite(BG3, 400, 500 + math.sin(globalTimer * 4 + 1) * 16)

    cogRotIncreaseTimer = cogRotIncreaseTimer + dt

    if cogRotIncreaseTimer > 1 then

        cogRotIncreaseTimer = 0

        cogRotLerpTo = cogRotLerpTo + 1

    end

    cogRot = lerp(cogRot, cogRotLerpTo, dt * 10)

    if PLAY:process() and globalTimer > 2.1 then

        player = nil
        opponent = nil
        enemyParts = nil
        
        sceneAt = "build"

    end

    if QUIT:process() then love.event.quit() end

    drawSprite(BIG_COG, 0, 600, 2, 2, cogRot)
    drawSprite(SMALL_COG, 800, 600, 2, 2, cogRot)
    drawSprite(SMALL_COG, 0, 0, 2, 2, cogRot)
    drawSprite(SMALL_COG, 800, 0, 2, 2, cogRot)

    drawSprite(TITLE, 400, 140 + math.sin(globalTimer * 2) * 12)

    MUSIC_SLIDER:process()
    MUSIC_SLIDER:draw()

    MUSIC_SLIDER.displayValue = MUSIC_SLIDER:value() * 100
    MUSIC_VOLUME = MUSIC_SLIDER:value() * 0.25

    SFX_SLIDER:process()
    SFX_SLIDER:draw()

    SFX_SLIDER.displayValue = SFX_SLIDER:value() * 100
    SFX_VOLUME = SFX_SLIDER:value() * 2

    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(MOUSE,xM,yM,0,SPRSCL * mouseScale,SPRSCL * mouseScale)

    -- Return scene
    return sceneAt
end