
function newRobot(x, y, rotation, control)

    return {

        x = x, y = y,

        leftPart = nil,
        rightPart = nil,
        upPart = nil,
        downPart = nil,

        draw = drawRobot,
        drawSmoke = drawRobotSmoke,
        drawUI = drawRobotUI,
        process = processRobot,
        control = control,

        tryingToAttack = false,
        tryingToMove = 0,

        rotationVel = 0,
        rotation = rotation,
        velocity = newVec(0, 0),

        knockback = newVec(0, 0)
    }

end

function processRobot(self, enemy)

    self.velocity.x = 0
    self.velocity.y = 0

    self:control()

    self.rotation = self.rotation + self.rotationVel * dt

    if self.rotation < -360 then self.rotation = self.rotation + 360 end
    if self.rotation > 360 then self.rotation = self.rotation - 360 end

    if self.leftPart ~= nil then

        self.leftPart:process(self)

        self.leftPart:collide(self, enemy)

    end

    if self.rightPart ~= nil then

        self.rightPart:process(self)

        self.rightPart:collide(self, enemy)

    end

    if self.upPart ~= nil then

        self.upPart:process(self)

        self.upPart:collide(self, enemy)

    end

    if self.downPart ~= nil then

        self.downPart:process(self)

        self.downPart:collide(self, enemy)

    end

    self.x = self.x + self.velocity.x * dt + self.knockback.x * dt
    self.y = self.y + self.velocity.y * dt + self.knockback.y * dt

    self.x = clamp(self.x, 0, 800)
    self.y = clamp(self.y, 0, 600)

    self.knockback.x = lerp(self.knockback.x, 0, dt * 2)
    self.knockback.y = lerp(self.knockback.y, 0, dt * 2)

end

ROBOT = love.graphics.newImage("data/graphics/images/woodBase.png")

function drawRobot(self)

    setColor(255, 255, 255)
    self.leftPart = drawPart(self.leftPart, self)
    self.rightPart = drawPart(self.rightPart, self)
    self.upPart = drawPart(self.upPart, self)
    self.downPart = drawPart(self.downPart, self)

    setColor(255, 255, 255)
    drawSprite(ROBOT, self.x, self.y, 1, 1, self.rotation / 180 * 3.14 + 1.57)

end

function drawRobotSmoke(self)

    self.leftPart = drawPartSmoke(self.leftPart, self)
    self.rightPart = drawPartSmoke(self.rightPart, self)
    self.upPart = drawPartSmoke(self.upPart, self)
    self.downPart = drawPartSmoke(self.downPart, self)

end

function drawRobotUI(self)

    self.leftPart = drawPartUI(self.leftPart, self)
    self.rightPart = drawPartUI(self.rightPart, self)
    self.upPart = drawPartUI(self.upPart, self)
    self.downPart = drawPartUI(self.downPart, self)

end
