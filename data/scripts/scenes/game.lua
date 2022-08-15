
function gameReload()
    
    opponent = newRobot(200, 400, 0, function(self)
    
        self.rotationVel = ((newVec(player.x - self.x, player.y - self.y):getRot() + love.math.noise(globalTimer) * 90) - self.rotation) / dt

        self.tryingToMove = clamp(love.math.noise(globalTimer) + 0.65, -1, 1) *  boolToInt(globalTimer > 1.4)
    
    end)

    parts = {"wheel", "spike", "gun", "rocketEngine", "TNT"}

    if enemyParts == nil then

        score = 0

        enemyParts = {"wheel", "spike"}

    else

        table.insert(enemyParts, parts[love.math.random(1, #parts - 1 + boolToInt(score > 4))])

    end

    local movingNumber = 0

    while movingNumber == 0 do
        taken = {}

        local index = love.math.random(1, #enemyParts); taken[index] = true
        opponent.rightPart = newPart(enemyParts[index], "right", love.math.random(0, math.min(score * 0.33, 3)))

        while taken[index] == true and not (#enemyParts < 2) and enemyParts[index].name ~= "rocketEngine" do
            
            index = love.math.random(1, #enemyParts)
            opponent.leftPart = newPart(enemyParts[index], "left", love.math.random(0, math.min(score * 0.33, 3)))

        end taken[index] = true

        while taken[index] == true and not (#enemyParts < 3) and enemyParts[index].name ~= "rocketEngine" do

            index = love.math.random(1, #enemyParts)
            opponent.upPart = newPart(enemyParts[index], "up", love.math.random(0, math.min(score * 0.33, 3)))

        end taken[index] = true

        while taken[index] == true and not (#enemyParts < 4) and enemyParts[index].name ~= "rocketEngine" do

            index = love.math.random(1, #enemyParts)
            opponent.downPart = newPart(enemyParts[index], "down", love.math.random(0, math.min(score * 0.33, 3)))

        end taken[index] = true

        if opponent.leftPart ~= nil then movingNumber = movingNumber + boolToInt(opponent.leftPart.name == "rocketEngine" or opponent.leftPart.name == "wheel") end

        if opponent.rightPart ~= nil then movingNumber = movingNumber + boolToInt(opponent.rightPart.name == "rocketEngine" or opponent.rightPart.name == "wheel") end

        if opponent.upPart ~= nil then movingNumber = movingNumber + boolToInt(opponent.upPart.name == "rocketEngine" or opponent.upPart.name == "wheel") end

        if opponent.downPart ~= nil then movingNumber = movingNumber + boolToInt(opponent.downPart.name == "rocketEngine" or opponent.downPart.name == "wheel") end

    end

    opponent.rotationVel = 60

    player.x = 600; player.y = 200
    player.rotationVel = 666

    particleSystemsUnder = {}
    particleSystemsOver = {}

    PLAYER_ARROW = love.graphics.newImage("data/graphics/images/arrow.png")

    BULLET_DIE_PARTICLES = loadJson("data/graphics/particles/bulletDie.json")

    bullets = {}

    globalTimer = 0

    endAnimation = 0

    CANNON_BALL = love.graphics.newImage("data/graphics/images/cannonBall.png")

    finished = false

    overdrive = false
    overdriveActivate = 0
    overdriveEndTimer = 0

    overdriveParticles = newParticleSystem(0, 0, loadJson("data/graphics/particles/overdrive.json"))

    playTrack("battle", 0.8)

    BG = love.graphics.newImage("data/graphics/images/battleBackground.png")

end

function gameDie()
    
end

function game()

    if overdriveActivate > 150 then

        if overdrive == false then

            overdriveEndTimer = 2

            playTrackPause("overdrive", 0.1)

        end

        overdrive = true

        overdriveEndTimer = overdriveEndTimer - dt

        if overdriveEndTimer < 0 then
            
            overdriveActivate = 0

            playTrack("battle", 0.8)
        
        end

    else

        overdriveActivate = math.max(overdriveActivate - dt * 4, 0)

        overdrive = false

    end

    -- Reset
    sceneAt = "game"
    
    setColor(155, 155, 155)
    clear(155, 155, 155)

    drawSprite(BG, 400, 300)
    setColor(255, 255, 255)

    local kill = {}                                            -- Draw particles under
    for id,P in ipairs(particleSystemsUnder) do
        P:process()

        if #P.particles == 0 and P.ticks == 0 and P.timer < 0 then table.insert(kill,id) end

    end particleSystemsUnder = wipeKill(kill,particleSystemsUnder)

    opponent:process(player)
    player:process(opponent)

    local kill = {}
    for id, bullet in ipairs(bullets) do

        local enemy = bullet.enemy

        bullet.x = bullet.x + bullet.vel.x * dt
        bullet.y = bullet.y + bullet.vel.y * dt

        setColor(255, 255, 255)
        drawSprite(CANNON_BALL, bullet.x, bullet.y, 1, 1, bullet.vel:getRot() / 180 * 3.14)

        if bullet.x < -100 or bullet.x > 900 or bullet.y < - 100 or bullet.y > 700 then

            table.insert(kill, id)

        else

            for partId, enemyPart in ipairs({enemy.leftPart or "none", enemy.rightPart or "none", enemy.upPart or "none", enemy.downPart or "none"}) do

                if enemyPart ~= "none" then

                    local enemyPartPos = newVec(enemy.x + enemyPart.offset.x, enemy.y + enemyPart.offset.y)

                    if newVec(bullet.x - enemyPartPos.x, bullet.y - enemyPartPos.y):getLen() < 30 then

                        enemyPart.hp = enemyPart.hp - bullet.damage

                        table.insert(kill, id)

                        shake(2, 2, 0.1)
                        shock(bullet.x, bullet.y, 0.1, 0.05, 0.2)

                        local particles = newParticleSystem(bullet.x, bullet.y, deepcopyTable(BULLET_DIE_PARTICLES))

                        particles.rotation = bullet.vel:getRot() + 180

                        table.insert(particleSystemsOver, particles)

                    end

                end

            end

        end

    end bullets = wipeKill(kill, bullets)

    opponent:draw()
    player:draw()

    opponent:drawSmoke()
    player:drawSmoke()

    setColor(255, 255, 255)
    drawSprite(PLAYER_ARROW, player.x, player.y - 36 + math.sin(globalTimer * 5) * 8)

    overdriveParticles.spawning = overdrive
    if overdrive then

        overdriveParticles.x = player.x
        overdriveParticles.y = player.y

    end

    overdriveParticles:process()

    opponent:drawUI()
    player:drawUI()

    setColor(0,0,0,155 * boolToInt(sceneAt == "game"))
    love.graphics.rectangle("fill", player.x - 24, player.y - 80, 48, 12)

    setColor(150,30,20,255 * boolToInt(sceneAt == "game"))

    if not overdrive then

        love.graphics.rectangle("fill", player.x - 24, player.y - 80, 48 * math.min(1, overdriveActivate / 150), 12)

    else

        local effect = math.abs(math.sin(globalTimer * 20))

        setColor(lerp(150, 255, effect),lerp(30, 255, effect),lerp(20, 255, effect),255 * boolToInt(sceneAt == "game"))

        love.graphics.rectangle("fill", player.x - 24, player.y - 80, 48 * overdriveEndTimer / 2, 12)

    end

    setColor(0,0,0,255 * boolToInt(sceneAt == "game"))
    love.graphics.rectangle("line", player.x - 24, player.y - 80, 48, 12)

    local kill = {}                                            -- Draw particles over
    for id,P in ipairs(particleSystemsOver) do
        P:process()

        if #P.particles == 0 and P.ticks == 0 and P.timer < 0 then table.insert(kill,id) end

    end particleSystemsOver = wipeKill(kill,particleSystemsOver)

    local movingParts = 0

    if opponent.leftPart ~= nil then movingParts = movingParts + boolToInt(opponent.leftPart.name == "rocketEngine" or opponent.leftPart.name == "wheel") end 

    if opponent.rightPart ~= nil then movingParts = movingParts + boolToInt(opponent.rightPart.name == "wheel") end 

    if opponent.upPart ~= nil then movingParts = movingParts + boolToInt(opponent.upPart.name == "wheel") end 

    if opponent.downPart ~= nil then movingParts = movingParts + boolToInt(opponent.downPart.name == "wheel") end 

    if player.leftPart ~= nil then movingParts = movingParts + boolToInt(player.leftPart.name == "rocketEngine" or player.leftPart.name == "wheel") end 

    if player.rightPart ~= nil then movingParts = movingParts + boolToInt(player.rightPart.name == "rocketEngine" or player.rightPart.name == "wheel") end 

    if player.upPart ~= nil then movingParts = movingParts + boolToInt(player.upPart.name == "rocketEngine" or player.upPart.name == "wheel") end 

    if player.downPart ~= nil then movingParts = movingParts + boolToInt(player.downPart.name == "rocketEngine" or player.downPart.name == "wheel") end 

    if overdrive then

        outlinedText(400 + love.math.random(-12, 12), 300 + love.math.random(-12, 12), 3, "OVERDRIVE", {255, 0, 0, 255 * math.abs(math.sin(overdriveEndTimer * 0.5))}, 2, 2)

    end

    if opponent.leftPart == nil and opponent.rightPart == nil and opponent.upPart == nil and opponent.downPart == nil then

        if finished == false then

            finished = true

            local particles = newParticleSystem(opponent.x, opponent.y, deepcopyTable(EXPLOSION))
            particles.ticks = 1

            table.insert(particleSystemsOver, particles)
            shake(16, 4, 0.2)
            shock(opponent.x, opponent.y, 0.8, 0.08, 0.4)

            playSound("applause")
            
        end

        trackVolume = endAnimation / 1.5

        transition = endAnimation / 1.5

        outlinedText(player.x, player.y - 48 - 48 * transition, 2, "+ 1 Item", {0, 255, 0, 255 * round(math.abs(math.sin(globalTimer * 3.14 * 8)))})

        endAnimation = endAnimation + dt

        if endAnimation > 1.5 then

            trackVolume = 1

            sceneAt = "build"

            score = score + 1

        end

    else if (player.leftPart == nil and player.rightPart == nil and player.upPart == nil and player.downPart == nil) then

        if finished == false then

            playSound("loose", 1, 1, 0.2)

            finished = true

            local particles = newParticleSystem(player.x, player.y, deepcopyTable(EXPLOSION))
            particles.ticks = 1

            table.insert(particleSystemsOver, particles)
            shake(16, 4, 0.2)
            shock(player.x, player.y, 0.8, 0.08, 0.4)
            
        end

        trackVolume = endAnimation / 1.5

        endAnimation = endAnimation + dt

        transition = endAnimation / 1.5

        if endAnimation > 1.5 then

            trackVolume = 1

            sceneAt = "endscreen"

        end
    
    else if movingParts == 0 then

        if finished == false then

            playSound("loose")

            finished = true
            
        end

        trackVolume = endAnimation / 1.5

        endAnimation = endAnimation + dt

        transition = endAnimation / 1.5

        if endAnimation > 1.5 then

            trackVolume = 1

            sceneAt = "endscreen"

        end

    end end end

    -- Return scene
    return sceneAt
end