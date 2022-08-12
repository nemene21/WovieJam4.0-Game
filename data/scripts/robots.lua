
function newRobot(x, y, rotation, control)

    return {

        x = x, y = y,

        leftPart = nil,
        rightPart = nil,
        upPart = nil,
        downPart = nil,

        draw = drawRobot,
        process = processRobot,
        control = control,

        tryingToAttack = false,
        tryingToMove = 0,

        rotationVel = 0,
        rotation = rotation,
        velocity = newVec(0, 0)
    }

end

function processRobot(self)

    self.velocity.x = 0
    self.velocity.y = 0

    self:control()

    self.rotation = self.rotation + self.rotationVel * dt

    if self.leftPart ~= nil then

        self.leftPart:process(self)

    end

    if self.rightPart ~= nil then

        self.rightPart:process(self)

    end

    if self.upPart ~= nil then

        self.upPart:process(self)

    end

    if self.downPart ~= nil then

        self.downPart:process(self)

    end

    self.x = self.x + self.velocity.x * dt
    self.y = self.y + self.velocity.y * dt

end

function drawRobot(self)


    setColor(0, 100, 255)
    love.graphics.circle("fill", self.x - camera[1], self.y - camera[2], 36)
    setColor(255, 255, 255)

    if self.leftPart ~= nil then

        self.leftPart:draw(self)

    end

    if self.rightPart ~= nil then

        self.rightPart:draw(self)

    end

    if self.upPart ~= nil then

        self.upPart:draw(self)

    end

    if self.downPart ~= nil then

        self.downPart:draw(self)

    end

end
