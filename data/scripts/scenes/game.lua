
function gameReload()
    
    opponent = newRobot(200, 400, 0, function(self)
    
        self.rotationVel = lerp(self.rotationVel, (newVec(player.x - self.x, player.y - self.y):getRot() - self.rotation) * 5, dt)

        self.tryingToMove = clamp(love.math.noise(globalTimer) + 0.5, -1, 1)
    
    end)

    opponent.rightPart = newPart("spike", "right")

    opponent.upPart = newPart("wheel", "up")
    opponent.downPart = newPart("wheel", "down")

    opponent.rotationVel = 60

    player.x = 600; player.y = 200
    player.rotationVel = 180

    particleSystemsUnder = {}
    particleSystemsOver = {}

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

    opponent:drawSmoke()
    player:drawSmoke()

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