
function newRobot(x, y, control)

    return {

        leftPart = nil,
        rightPart = nil,
        upPart = nil,
        downPart = nil,

        draw = drawRobot,
        process = processRobot,
        control = control,

        tryingToAttack = false,
        rotation = 0,
        velocity = 0
    }

end

function processRobot(self)

    self:control()

    if self.leftPart ~= nil then

        self.leftPart:process()

    end

    if self.rightPart ~= nil then

        self.rightPart:process()

    end

    if self.upPart ~= nil then

        self.upPart:process()

    end

    if self.downPart ~= nil then

        self.downPart:process()

    end

end

function drawRobot(self)

    if self.leftPart ~= nil then

        self.leftPart:draw()

    end

    if self.rightPart ~= nil then

        self.rightPart:draw()

    end

    if self.upPart ~= nil then

        self.upPart:draw()

    end

    if self.downPart ~= nil then

        self.downPart:draw()

    end

end
