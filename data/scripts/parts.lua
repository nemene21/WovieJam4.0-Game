
romanLetters = {
    "I",
    "II",
    "III",
    "IV"
}

WHEEL_SMOKE = loadJson("data/graphics/particles/wheelSmoke.json")

function newWheel(tier) -- Wheel

    return {

        process = processWheel,
        draw = drawWheel,

        movement = 0,

        distance = 45,

        rotation = 90,

        fancyName = "Wheel " .. romanLetters[tier + 1],

        particles = newParticleSystem(0, 0, deepcopyTable(WHEEL_SMOKE)),

        maxHp = 75 + 20 * tier,
        hp = 75 + 20 * tier,

        tier = tier,

        barLerp = 1,

        tooltipMessages = {

            "Makes the robot move forward and back",
            "Hp " .. tostring(75 + 20 * tier),
            "Speed 1"

        }

    }

end

function processWheel(self, robot, enemy)

    self.offset = self.offset:rotate(robot.rotationVel * dt)

    self.movement = lerp(self.movement, robot.tryingToMove * 200, dt * 5)

    local newWheelVel = newVec(self.movement, 0)
    newWheelVel:rotate(robot.rotation)

    robot.velocity.x = robot.velocity.x + newWheelVel.x
    robot.velocity.y = robot.velocity.y + newWheelVel.y

    self.particles.x = robot.x + self.offset.x
    self.particles.y = robot.y + self.offset.y
    self.particles:process()

    setColor(255, 255, 255)

end

WHEEL = {
    love.graphics.newImage("data/graphics/images/woodWheel.png"),
    love.graphics.newImage("data/graphics/images/ironWheel.png"),
    love.graphics.newImage("data/graphics/images/goldWheel.png"),
    love.graphics.newImage("data/graphics/images/diamondWheel.png")
}

function drawWheel(self, robot)

    local effect = 1 - self.hp / self.maxHp

    drawSprite(WHEEL[self.tier + 1], robot.x + (self.offset.x or 0), robot.y + (self.offset.y or 0), 1 - self.iFrames / 0.2 * 0.15, 1 - self.iFrames / 0.2 * 0.15, ((robot.rotation or 0) - (self.rotation or 0)) / 180 * 3.14 + math.sin(globalTimer * 15 + (self.rotation or 0)) * 0.15 * effect)

end

function newSpike(tier) -- Spike

    return {

        process = processSpike,
        draw = drawSpike,

        distance = 57,

        maxHp = 100 + 20 * tier,
        hp = 100 + 20 * tier,

        damage = 3 + tier,
        
        tier = tier,

        barLerp = 1,

        fancyName = "Spike " .. romanLetters[tier + 1],

        tooltipMessages = {

            "Does a lot more damage on impact",
            "Hp " .. tostring(100 + 20 * tier),
            "Damage " .. tostring(10 * (3 + tier)) .. " (speed adds damage)"

        }

    }

end

SPIKE = {
    love.graphics.newImage("data/graphics/images/woodSpike.png"),
    love.graphics.newImage("data/graphics/images/ironSpike.png"),
    love.graphics.newImage("data/graphics/images/goldSpike.png"),
    love.graphics.newImage("data/graphics/images/diamondSpike.png")
}

function processSpike(self, robot, enemy)

    self.offset = self.offset:rotate(robot.rotationVel * dt)

end

function drawSpike(self, robot)

    local effect = 1 - self.hp / self.maxHp

    drawSprite(SPIKE[self.tier + 1], robot.x + (self.offset.x or 0), robot.y + (self.offset.y or 0), 1 + self.iFrames / 0.2 * 0.15, 1 - self.iFrames / 0.2 * 0.15, ((robot.rotation or 0) - (self.rotation or 0)) / 180 * 3.14 + 1.57 + math.sin(globalTimer * 15 + (self.rotation or 0)) * 0.15 * effect)

end

EXPLOSION = loadJson("data/graphics/particles/explosion.json")

function newTNT(tier) -- TNT

    return {

        process = processTNT,
        draw = drawTNT,

        distance = 42,

        maxHp = 1,
        hp = 1,

        damage = 100 + 50 * tier,
        
        tier = tier,

        barLerp = 1,

        fancyName = "TNT " .. romanLetters[tier + 1],

        particles = newParticleSystem(0, 0, deepcopyTable(EXPLOSION)),

        tooltipMessages = {

            "Very low hp, very high damage, big splash radius",
            "Hp " .. 1,
            "Damage " .. tostring(100 + 50 * tier) .. " (speed adds damage)"

        }

    }

end

TNT = {
    love.graphics.newImage("data/graphics/images/woodTNT.png"),
    love.graphics.newImage("data/graphics/images/ironTNT.png"),
    love.graphics.newImage("data/graphics/images/goldTNT.png"),
    love.graphics.newImage("data/graphics/images/diamondTNT.png")
}

function processTNT(self, robot, enemy)

    if overdrive and robot == player then self.hp = - 1 end

    if self.hp <= 0 then

        playSound("tntExplode")

        local partPos = newVec(robot.x + self.offset.x, robot.y + self.offset.y)

        shock(partPos.x, partPos.y, 0.4, 0.075, 0.4)
        shake(16, 3, 0.2)

        for id, enemyPart in ipairs({enemy.leftPart or "none", enemy.rightPart or "none", enemy.upPart or "none", enemy.downPart or "none"}) do
    
            if enemyPart ~= "none" then
    
                local enemyPartPos = newVec(enemy.x + enemyPart.offset.x, enemy.y + enemyPart.offset.y)
    
                if newVec(partPos.x - enemyPartPos.x, partPos.y - enemyPartPos.y):getLen() < 196 then

                    enemyPart.hp = enemyPart.hp - self.damage * 0.5

                end

            end

        end

    end

    self.particles.x = robot.x + self.offset.x
    self.particles.y = robot.y + self.offset.y

    self.offset = self.offset:rotate(robot.rotationVel * dt)

end

function drawTNT(self, robot)

    local effect = 1 - self.hp / self.maxHp

    drawSprite(TNT[self.tier + 1], robot.x + (self.offset.x or 0), robot.y + (self.offset.y or 0), 1 + self.iFrames / 0.2 * 0.15, 1 - self.iFrames / 0.2 * 0.15, ((robot.rotation or 0) - (self.rotation or 0)) / 180 * 3.14 + 1.57 + math.sin(globalTimer * 15 + (self.rotation or 0)) * 0.15 * effect + 0.785)
end

ROCKET_ENGINE_FIRE = loadJson("data/graphics/particles/rocketEngine.json")

function newRocketEngine(tier) -- Rocket engine

    return {

        tier = tier,

        process = processRocketEngine,
        draw = drawRocketEngine,

        movement = 0,

        distance = 45,

        particles = newParticleSystem(0, 0, deepcopyTable(ROCKET_ENGINE_FIRE)),

        maxHp = 35 + 15 * tier,
        hp = 35 + 15 * tier,

        barLerp = 1,

        fancyName = "Rocket Engine " .. romanLetters[tier + 1],

        tooltipMessages = {

            "Makes the robot move forward. cannot move backwards",
            "Hp " .. tostring(35 + 15 * tier),
            "Speed 2"

        }

    }

end

function processRocketEngine(self, robot, enemy)

    self.offset = self.offset:rotate(robot.rotationVel * dt)

    self.movement = lerp(self.movement, math.max(robot.tryingToMove, 0) * 400, dt * 5)

    local newRocketVel = newVec(self.movement, 0)
    newRocketVel:rotate(self.offset:getRot() + 180)

    robot.velocity.x = robot.velocity.x + newRocketVel.x
    robot.velocity.y = robot.velocity.y + newRocketVel.y

    self.particles.x = robot.x + self.offset.x
    self.particles.y = robot.y + self.offset.y
    self.particles.rotation = self.offset:getRot()
    self.particles.tickSpeed.a = lerp(0.1, 0.02, robot.tryingToMove)
    self.particles.tickSpeed.b = lerp(0.1, 0.03, robot.tryingToMove)
    self.particles.particleData.color.a.a = robot.tryingToMove * 0.75
    self.particles.particleData.color.a.b = robot.tryingToMove
    self.particles:process()

    setColor(255, 255, 255)

end

ROCKET_ENGINE_IMAGE = {

    love.graphics.newImage("data/graphics/images/woodJet.png"),
    love.graphics.newImage("data/graphics/images/ironJet.png"),
    love.graphics.newImage("data/graphics/images/goldJet.png"),
    love.graphics.newImage("data/graphics/images/diamondJet.png")

}

function drawRocketEngine(self, robot)

    local effect = 1 - self.hp / self.maxHp

    drawSprite(ROCKET_ENGINE_IMAGE[self.tier + 1], robot.x + (self.offset.x or 0), robot.y + (self.offset.y or 0), 1 + self.iFrames / 0.2 * 0.15, 1 - self.iFrames / 0.2 * 0.15, ((robot.rotation or 0) - (self.rotation or 0)) / 180 * 3.14 + math.sin(globalTimer * 15 + (self.rotation or 0)) * 0.15 * effect - 1.57)
end

function newGun(tier) -- Rocket engine

    return {

        tier = tier,

        process = processGun,
        draw = drawGun,

        distance = 45,

        particles = newParticleSystem(0, 0, deepcopyTable(ROCKET_ENGINE_FIRE)),

        maxHp = 35 + 15 * tier,
        hp = 35 + 15 * tier,

        firerate = 1 + 0.2 * tier,

        shootTimer = 1,

        barLerp = 1,

        shootAnimation = 0,

        fancyName = "Gun " .. romanLetters[tier + 1],

        tooltipMessages = {

            "Shoots in its direction",
            "Hp " .. tostring(35 + 15 * tier),
            "Damage " .. tostring(8),
            "Firerate x" .. tostring(1 + 0.2 * tier)

        }

    }

end

function processGun(self, robot, enemy)

    self.shootAnimation = lerp(self.shootAnimation, 0, dt * 12)

    self.offset = self.offset:rotate(robot.rotationVel * dt)

    self.shootTimer = self.shootTimer - dt * (self.firerate + boolToInt(overdrive and robot == player) * 10)

    if self.shootTimer < 0 then

        self.shootAnimation = 0.4

        self.shootTimer = 0.18

        local bulletVel = deepcopyTable(self.offset)
        bulletVel:normalize()

        bulletVel:rotate(love.math.random(-8, 8))

        bulletVel.x = bulletVel.x * 900
        bulletVel.y = bulletVel.y * 900

        shake(1, 2, 0.1)

        playSound("shoot", love.math.random(60, 180) * 0.01)

        table.insert(bullets, {

            enemy = enemy,

            vel = bulletVel,

            x = robot.x + (self.offset.x or 0) * 2,
            y = robot.y + (self.offset.y or 0) * 2,

            damage = 8

        })

    end

    setColor(255, 255, 255)

end

GUN_IMAGE = {

    love.graphics.newImage("data/graphics/images/woodCannon.png"),
    love.graphics.newImage("data/graphics/images/ironCannon.png"),
    love.graphics.newImage("data/graphics/images/goldCannon.png"),
    love.graphics.newImage("data/graphics/images/diamondCannon.png")

}

function drawGun(self, robot)

    local effect = 1 - self.hp / self.maxHp

    drawSprite(GUN_IMAGE[self.tier + 1], robot.x + (self.offset.x or 0), robot.y + (self.offset.y or 0), 1 + self.iFrames / 0.2 * 0.15 - self.shootAnimation, 1 - self.iFrames / 0.2 * 0.15 + self.shootAnimation, ((robot.rotation or 0) - (self.rotation or 0)) / 180 * 3.14 + math.sin(globalTimer * 15 + (self.rotation or 0)) * 0.15 * effect - 1.57)

end

PARTS = {

wheel = newWheel,
spike = newSpike,
rocketEngine = newRocketEngine,
gun = newGun,
TNT = newTNT

}

SMOKE_PARTICLES = loadJson("data/graphics/particles/partLowSmoke.json")

function newPart(name, side, tier)

    if PARTS[name] == nil then return end

    local part = PARTS[name](tier)

    part.name = name

    part.collide = collidePart

    part.iFrames = 0

    part.smokeParticles = newParticleSystem(0, 0, deepcopyTable(SMOKE_PARTICLES))

    if side == "right" then

        part.offset = newVec(part.distance, 0)
        part.rotation = part.rotation or 0

    end

    if side == "left" then

        part.offset = newVec(-part.distance, 0)
        part.rotation = part.rotation or 180

    end

    if side == "up" then

        part.offset = newVec(0, - part.distance + 12)
        part.rotation = part.rotation or 90

    end

    if side == "down" then

        part.offset = newVec(0, part.distance - 12)
        part.rotation = part.rotation or -90

    end

    return part

end

COLLIDE_PARTICLES = loadJson("data/graphics/particles/impact.json")

function collidePart(part, robot, enemy)

    part.iFrames = clamp(part.iFrames - dt, 0, 0.5)

    local partPos = newVec(robot.x + part.offset.x, robot.y + part.offset.y)

    if part.iFrames > 0 then return end

    for id, enemyPart in ipairs({enemy.leftPart or "none", enemy.rightPart or "none", enemy.upPart or "none", enemy.downPart or "none"}) do

        if enemyPart ~= "none" then

            local enemyPartPos = newVec(enemy.x + enemyPart.offset.x, enemy.y + enemyPart.offset.y)

            -- love.graphics.line(enemyPartPos.x - camera[1], enemyPartPos.y - camera[2], partPos.x - camera[1], partPos.y - camera[2])

            if newVec(partPos.x - enemyPartPos.x, partPos.y - enemyPartPos.y):getLen() < 48 and not (enemyPart.iFrames > 0) then

                local momentum = newVec(enemy.velocity.x + robot.velocity.x, enemy.velocity.y + robot.velocity.y):getLen() / 600

                playSound("collide", love.math.random(50, 100) * 0.01, 12, momentum + 0.4)

                local enemySpeedFactor = enemy.velocity:getLen() / 400 * 0.5 + momentum * 0.5
                local selfSpeedFactor = robot.velocity:getLen() / 400 * 0.5 + momentum * 0.5

                part.iFrames = 0.4

                part.hp = part.hp - 10 * enemySpeedFactor * (enemyPart.damage or 1) * (part.shield or 1)

                if robot == player then

                    overdriveActivate = overdriveActivate + 10 * enemySpeedFactor * (enemyPart.damage or 1) * (part.shield or 1)

                else
                    
                    overdriveActivate = overdriveActivate + 10 * selfSpeedFactor * (part.damage or 1) * (enemyPart.shield or 1)
                
                end

                enemyPart.hp = enemyPart.hp - 10 * selfSpeedFactor * (part.damage or 1) * (enemyPart.shield or 1)

                local newKnockback = newVec(momentum * 600, 0):rotate(newVec(robot.x - enemy.x, robot.y - enemy.y):getRot() + 180)

                robot.knockback.x = robot.knockback.x + newKnockback.x * - 0.5
                robot.knockback.y = robot.knockback.y + newKnockback.y * - 0.5

                enemy.knockback.x = enemy.knockback.x + newKnockback.x * 0.5
                enemy.knockback.y = enemy.knockback.y + newKnockback.y * 0.5

                enemy.iFrames = 0.4

                local particles = newParticleSystem((partPos.x + enemyPartPos.x) * 0.5, (partPos.y + enemyPartPos.y) * 0.5, deepcopyTable(COLLIDE_PARTICLES))

                shock((partPos.x + enemyPartPos.x) * 0.5, (partPos.y + enemyPartPos.y) * 0.5, 0.1, 0.05, 0.2)

                shake(5, 3, 0.2)

                particles.rotation = enemy.knockback:getRot() + 90

                table.insert(particleSystemsOver, particles)

                particles = deepcopyTable(particles)

                particles.rotation = enemy.knockback:getRot() - 90

                table.insert(particleSystemsOver, particles)

                return

            end

        end

    end

end

PART_DIE = loadJson("data/graphics/particles/partDie.json")

function drawPart(part, robot)

    if part ~= nil then

        setColor(255, 255, 255)

        love.graphics.setShader(SHADERS.FLASH); SHADERS.FLASH:send("intensity", boolToInt(part.iFrames > 0.2))
        part:draw(robot)

        love.graphics.setShader()

        part.smokeParticles.x = robot.x + part.offset.x
        part.smokeParticles.y = robot.y + part.offset.y

        part.smokeParticles:process()

        if part.hp <= 0 then
            
            if part.particles ~= nil then
                part.particles.ticks = 1

                table.insert(particleSystemsUnder, part.particles)
            end

            part.smokeParticles.ticks = 0
            table.insert(particleSystemsOver, part.smokeParticles)

            table.insert(particleSystemsOver, newParticleSystem(robot.x + part.offset.x, robot.y + part.offset.y, deepcopyTable(PART_DIE)))
            shock(robot.x + part.offset.x, robot.y + part.offset.y, 0.15, 0.05, 0.3)

            shake(10, 3, 0.2)

            playSound("partDie")

            part = nil

        end

    end

    return part
    
end

function drawPartSmoke(part, robot)

    if part ~= nil then

        part.smokeParticles.x = robot.x + part.offset.x
        part.smokeParticles.y = robot.y + part.offset.y

        part.smokeParticles.x = robot.x + part.offset.x
        part.smokeParticles.y = robot.y + part.offset.y

        local effect = 1 - part.hp / part.maxHp
        effect = effect * effect

        part.smokeParticles.particleData.color.a.a = 0.65 * effect
        part.smokeParticles.particleData.color.a.b = 0.8 * effect

        part.smokeParticles:process()

    end

    return part

end

function drawPartUI(part, robot)

    if part ~= nil then

        part.barLerp = lerp(part.barLerp, part.hp / part.maxHp, dt * 2)

        setColor(0,0,0,155 * boolToInt(sceneAt == "game"))
        love.graphics.rectangle("fill", robot.x + part.offset.x - 18, robot.y + part.offset.y - 16, 36, 8)

        setColor(255,255,255,255 * boolToInt(sceneAt == "game"))
        love.graphics.rectangle("fill", robot.x + part.offset.x - 18, robot.y + part.offset.y - 16, 36 * part.barLerp, 8)

        setColor(255,0,68,255 * boolToInt(sceneAt == "game"))
        love.graphics.rectangle("fill", robot.x + part.offset.x - 18, robot.y + part.offset.y - 16, 36 * part.hp / part.maxHp, 8)

        setColor(0,0,0,255 * boolToInt(sceneAt == "game"))
        love.graphics.rectangle("line", robot.x + part.offset.x - 18, robot.y + part.offset.y - 16, 36, 8)

        setColor(255, 255, 255)

    end

    return part
    
end

function drawPartToolTip(part)

    local xOffset = 0

    local width = FONT:getWidth(part.fancyName) + 24
    local height = FONT:getHeight(part.fancyName) + 8
    local lines = #part.tooltipMessages + 1

    for id, line in ipairs(part.tooltipMessages) do

        width = math.max(width, FONT:getWidth(line) + 24)
        height = height + FONT:getHeight(line) + 8

    end

    xOffset = math.min(xM - width * 0.5, 0)

    outlinedText(xM - xOffset, yM - height + 4, 2, part.fancyName, {0, 255, 0})

    for id, line in ipairs(part.tooltipMessages) do

        outlinedText(xM - xOffset, yM - height / lines * (#part.tooltipMessages - id + 1), 2, line, {255, 255, 255})

    end

end