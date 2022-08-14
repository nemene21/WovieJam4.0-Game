
function gameReload()
    
    opponent = newRobot(200, 400, 0, function(self)
    
        self.rotationVel = lerp(self.rotationVel, (newVec(player.x - self.x, player.y - self.y):getRot() - self.rotation) * 10, dt)

        self.tryingToMove = clamp(love.math.noise(globalTimer) + 1, -1, 1) *  boolToInt(globalTimer > 1.4)
    
    end)

    parts = {"wheel", "spike", "gun", "rocketEngine"}

    score = 0

    if enemyParts == nil then

        enemyParts = {"wheel", "spike"}
        enemyPartLevels = {0, 0}

    else

        table.insert(enemyParts, parts[love.math.random(1, #parts)])
        table.insert(enemyPartLevels, love.math.random(math.floor(math.min(3 * score / 1.5 * 0.5, 3)), math.floor(math.min(3 * score / 1.5, 3))))

    end

    taken = {}

    local index = love.math.random(1, #enemyParts); taken[index] = true
    opponent.leftPart = newPart(enemyParts[index], "left", 0)

    while taken[index] == true and not (#enemyParts < 2) do
        
        index = love.math.random(1, #enemyParts)
        opponent.rightPart = newPart(enemyParts[index], "right", 0)

    end taken[index] = true

    while taken[index] == true and not (#enemyParts < 3) do

        index = love.math.random(1, #enemyParts)
        opponent.upPart = newPart(enemyParts[index], "up", 0)

    end taken[index] = true

    while taken[index] == true and not (#enemyParts < 4) do

        index = love.math.random(1, #enemyParts)
        opponent.downPart = newPart(enemyParts[index], "down", 0)

    end taken[index] = true

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

end

function gameDie()
    
end

function game()
    -- Reset
    sceneAt = "game"
    
    setColor(255, 255, 255)
    clear(155, 155, 155)

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

        setColor(255, 255, 0)
        love.graphics.circle("fill", bullet.x - camera[1], bullet.y - camera[2], 8)
        setColor(255, 255, 255)

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

    opponent:drawUI()
    player:drawUI()

    local kill = {}                                            -- Draw particles over
    for id,P in ipairs(particleSystemsOver) do
        P:process()

        if #P.particles == 0 and P.ticks == 0 and P.timer < 0 then table.insert(kill,id) end

    end particleSystemsOver = wipeKill(kill,particleSystemsOver)

    if opponent.leftPart == nil and opponent.rightPart == nil and opponent.upPart == nil and opponent.downPart == nil then

        endAnimation = endAnimation + dt

        transition = endAnimation / 1.5

        if endAnimation > 1.5 then

            sceneAt = "build"

            score = score + 1

        end

    else if player.leftPart == nil and player.rightPart == nil and player.upPart == nil and player.downPart == nil then

        endAnimation = endAnimation + dt

        transition = endAnimation / 1.5

        if endAnimation > 1.5 then

            sceneAt = "menu"

        end

    end end

    -- Return scene
    return sceneAt
end