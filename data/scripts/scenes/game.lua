
function gameReload()
    
    opponent = newRobot(200, 400, 0, function(self)
    
        self.rotationVel = lerp(self.rotationVel, (newVec(player.x - self.x, player.y - self.y):getRot() - self.rotation) * 10, dt)

        self.tryingToMove = clamp(love.math.noise(globalTimer) + 1, -1, 1) *  boolToInt(globalTimer > 1.4)
    
    end)

    right = {"spike", "gun"}
    left  = {"wheel", "spike", "gun", "rocketEngine"}
    up    = {"wheel"}
    down  = {"wheel"}

    opponent.leftPart  = newPart(left[love.math.random(1, #left)], "left")
    if love.math.random(0, 100) > 25 then opponent.rightPart = newPart(right[love.math.random(1, #right)], "right") end
    opponent.upPart    = newPart(up[love.math.random(1, #up)], "up")
    opponent.downPart  = newPart(down[love.math.random(1, #down)], "down")

    opponent.rotationVel = 60

    player.x = 600; player.y = 200
    player.rotationVel = 666

    particleSystemsUnder = {}
    particleSystemsOver = {}

    PLAYER_ARROW = love.graphics.newImage("data/graphics/images/arrow.png")

    BULLET_DIE_PARTICLES = loadJson("data/graphics/particles/bulletDie.json")

    bullets = {}

    globalTimer = 0

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

    opponent:draw()
    player:draw()


    local kill = {}
    for id, bullet in ipairs(bullets) do

        local enemy = bullet.enemy

        bullet.x = bullet.x + bullet.vel.x * dt
        bullet.y = bullet.y + bullet.vel.y * dt

        setColor(255, 255, 0)
        love.graphics.circle("fill", bullet.x - camera[1], bullet.y - camera[2], 8)
        setColor(255, 255, 255)

        for partId, enemyPart in ipairs({enemy.leftPart or "none", enemy.rightPart or "none", enemy.upPart or "none", enemy.downPart or "none"}) do

            if enemyPart ~= "none" then

                local enemyPartPos = newVec(enemy.x + enemyPart.offset.x, enemy.y + enemyPart.offset.y)

                if newVec(bullet.x - enemyPartPos.x, bullet.y - enemyPartPos.y):getLen() < 30 then

                    enemyPart.hp = enemyPart.hp - bullet.damage

                    table.insert(kill, id)

                    shake(2, 2, 0.1)
                    shock(bullet.x, bullet.y, 0.1, 0.05, 0.1)

                    local particles = newParticleSystem(bullet.x, bullet.y, deepcopyTable(BULLET_DIE_PARTICLES))

                    particles.rotation = bullet.vel:getRot() + 180

                    table.insert(particleSystemsOver, particles)

                end

            end

        end

    end bullets = wipeKill(kill, bullets)

    opponent:drawSmoke()
    player:drawSmoke()

    setColor(255, 255, 255)
    drawSprite(PLAYER_ARROW, player.x, player.y - 24 + math.sin(globalTimer * 5) * 8)

    opponent:drawUI()
    player:drawUI()

    local kill = {}                                            -- Draw particles over
    for id,P in ipairs(particleSystemsOver) do
        P:process()

        if #P.particles == 0 and P.ticks == 0 and P.timer < 0 then table.insert(kill,id) end

    end particleSystemsOver = wipeKill(kill,particleSystemsOver)

    -- Return scene
    return sceneAt
end