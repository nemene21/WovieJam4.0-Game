
WHEEL_SMOKE = loadJson("data/graphics/particles/wheelSmoke.json")

function newWheel() -- Wheel

    return {

        process = processWheel,
        draw = drawWheel,

        movement = 0,

        distance = 48,

        rotation = 90,

        particles = newParticleSystem(0, 0, deepcopyTable(WHEEL_SMOKE)),

        maxHp = 75,
        hp = 75,

        barLerp = 1

    }

end

function processWheel(self, robot)

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

WHEEL = love.graphics.newImage("data/graphics/images/woodWheel.png")

function drawWheel(self, robot)

    drawSprite(WHEEL, robot.x + self.offset.x or 0, robot.y + self.offset.y or 0, 1 - self.iFrames / 0.2 * 0.15, 1 - self.iFrames / 0.2 * 0.15, ((robot.rotation or 0) - (self.rotation or 0)) / 180 * 3.14)

end

function newSpike() -- Spike

    return {

        process = processSpike,
        draw = drawSpike,

        distance = 60,

        maxHp = 100,
        hp = 100,

        damage = 3,

        barLerp = 1

    }

end

WOOD_SPIKE = love.graphics.newImage("data/graphics/images/woodSpike.png")

function processSpike(self, robot)

    self.offset = self.offset:rotate(robot.rotationVel * dt)

end

function drawSpike(self, robot)

    drawSprite(WOOD_SPIKE, robot.x + self.offset.x or 0, robot.y + self.offset.y or 0, 1 + self.iFrames / 0.2 * 0.15, 1 - self.iFrames / 0.2 * 0.15, ((robot.rotation or 0) - (self.rotation or 0)) / 180 * 3.14 + 1.57)

end

PARTS = {

wheel = newWheel,
spike = newSpike

}

SMOKE_PARTICLES = loadJson("data/graphics/particles/partLowSmoke.json")

function newPart(name, side)

    local part = PARTS[name]()

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

                local momentum = newVec(enemy.velocity.x + robot.velocity.x, enemy.velocity.y + robot.velocity.y):getLen() / 500

                part.iFrames = 0.4

                part.hp = part.hp - 10 * momentum * (enemyPart.damage or 1) * (enemyPart.shield or 1)

                enemyPart.hp = enemyPart.hp - 10 * momentum * (part.damage or 1) * (part.shield or 1)

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
                part.particles.ticks = 0

                table.insert(particleSystemsUnder, part.particles)
            end

            part.smokeParticles.ticks = 0
            table.insert(particleSystemsOver, part.smokeParticles)

            table.insert(particleSystemsOver, newParticleSystem(robot.x + part.offset.x, robot.y + part.offset.y, deepcopyTable(PART_DIE)))
            shock(robot.x + part.offset.x, robot.y + part.offset.y, 0.15, 0.05, 0.3)

            shake(10, 3, 0.2)

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

        part.smokeParticles.particleData.color.a.a = 0.3 * effect
        part.smokeParticles.particleData.color.a.b = 0.5 * effect

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

        setColor(255,0,0,255 * boolToInt(sceneAt == "game"))
        love.graphics.rectangle("fill", robot.x + part.offset.x - 18, robot.y + part.offset.y - 16, 36 * part.hp / part.maxHp, 8)

        setColor(0,0,0,255 * boolToInt(sceneAt == "game"))
        love.graphics.rectangle("line", robot.x + part.offset.x - 18, robot.y + part.offset.y - 16, 36, 8)

        setColor(255, 255, 255)

    end

    return part
    
end