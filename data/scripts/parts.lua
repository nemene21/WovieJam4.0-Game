
function newWheel() -- Wheel

    return {

        process = processWheel,
        draw = drawWheel,

        movement = 0

    }

end

function processWheel(self, robot)

    self.offset = self.offset:rotate((robot.rotation - self.rotation) - self.offset:getRot())

    self.movement = lerp(self.movement, robot.tryingToMove * 200, dt * 5)

    local newWheelVel = newVec(self.movement, 0)
    newWheelVel:rotate(robot.rotation)

    robot.rotation = robot.rotation + self.movement * 0.00005 * self.rotation

    robot.velocity.x = robot.velocity.x + newWheelVel.x
    robot.velocity.y = robot.velocity.y + newWheelVel.y

end

function drawWheel(self, robot)

    setColor(0, 255, 255)
    love.graphics.circle("fill", robot.x + self.offset.x - camera[1], robot.y + self.offset.y - camera[2], 24)
    setColor(255, 255, 255)

end

function newSpike() -- Spike

    return {

        process = processSpike,
        draw = drawSpike

    }

end

function processSpike(self, robot)

    self.offset = self.offset:rotate((robot.rotation - self.rotation) - self.offset:getRot())

end

function drawSpike(self, robot)

    setColor(255, 0, 0)
    love.graphics.circle("fill", robot.x + self.offset.x or 0 - camera[1], robot.y + self.offset.y or 0 - camera[2], 24)
    setColor(255, 255, 255)

end

PARTS = {

wheel = newWheel,
spike = newSpike

}

function newPart(name, side)

    local part = PARTS[name]()

    if side == "right" then

        part.offset = newVec(60, 0)
        part.rotation = 0

    end

    if side == "left" then

        part.offset = newVec(-60, 0)
        part.rotation = 180

    end

    if side == "up" then

        part.offset = newVec(0, -48)
        part.rotation = 90

    end

    if side == "down" then

        part.offset = newVec(0, 48)
        part.rotation = -90

    end

    return part

end