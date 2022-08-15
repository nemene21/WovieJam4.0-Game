function newButton(x, y, text)
    return {x = x, y = y, text = text, animation = 0, process = processButton}
end

function processButton(btn)

    local pressed = false

    if yM > btn.y - 36 and yM < btn.y + 36 then

        btn.animation = lerp(btn.animation, 1, dt * 10)

        if mouseJustPressed(1) then
            
            pressed = true

            playSound("click")
        
        end

    else

        btn.animation = lerp(btn.animation, 0, dt * 10)

    end
    
    local scale = 1 + 0.2 * btn.animation
    local offsetY = - 16 * btn.animation

    if btn.animation > 0.01 then

        setColor(0, 40, 89)
        love.graphics.rectangle("fill", 0, btn.y - 32 * btn.animation, 800, 64 * btn.animation)

    end

    outlinedText(btn.x, btn.y, 2, btn.text, {255, 255, 255}, scale + 0.8, scale + 0.8, 0.5, 0.5)

    return pressed
end


interactIconScale = 0; interacting = false

interactLastPos = newVec(0, 0)

function processInteract()

    interactIconScale = lerp(interactIconScale, boolToInt(interacting), dt * 20)

    if interactIconScale > 0 and not interacting then

        drawInteract(interactLastPos.x, interactLastPos.y)

    end

    interacting = false

end

function drawInteract(x, y, fromProcess)

    interacting = true; interactLastPos = newVec(x, y)
    
    local sine = math.sin(globalTimer * 2)
    drawSprite(IMAGE_F, x, y + sine * 10, (1 + math.sin(globalTimer * 10) * 0.1) * interactIconScale, (1 + math.sin(globalTimer * 10 + 3.14) * 0.1) * interactIconScale)

end

-- SLIDERS
SLIDER_TRACK = love.graphics.newImage("data/graphics/images/UI/sliderTrack.png")
SLIDER_NOTCH = love.graphics.newImage("data/graphics/images/UI/sliderNotch.png")

function newSlider(x, y, name, point, snap, unit)
    local point = point or 1

    point = point - 0.5

    return {name = name, x = x, y = y, held = false, point = point, snap = snap or 0.001, unit = unit or "", process = processSlider, draw = drawSlider, takeAnimation = 0, lastPoint = 0, value = getSliderValue}
end

function processSlider(slider)

    slider.takeAnimation = lerp(slider.takeAnimation, 0, dt * 4)

    if mouseJustPressed(1) then

        if newVec((slider.x + slider.point * 400) - (xM + camera[1]), slider.y + 64 - yM):getLen() < 24 then

            slider.held = true

            slider.takeAnimation = 0.4

        end

    end

    if not mousePressed(1) then slider.held = false end

    if slider.held then

        slider.point = snap((clamp(xM + camera[1], slider.x - 100, slider.x + 100) - slider.x) / 200, slider.snap) - slider.snap

    end

    slider.pointMoveAnim = lerp(slider.pointMoveAnim or 0, clamp(math.abs(slider.lastPoint - slider.point) * dt * 500, 0, 0.85), dt * 12)

    slider.lastPoint = slider.point

end

function drawSlider(slider)

    outlinedText(slider.x - camera[1], slider.y, 2, slider.name, {255, 255, 255}, 1, 1, 0.5, 0.5)

    outlinedText(slider.x - camera[1], slider.y + 64 - 24 * slider.pointMoveAnim - 32, 2, (slider.displayValue or "none")..slider.unit, {255, 255, 255}, 1 + slider.pointMoveAnim * 0.5, 1 - slider.pointMoveAnim * 0.5, 0.5, 0.5)

    drawSprite(SLIDER_TRACK, slider.x, slider.y + 64)
    drawSprite(SLIDER_NOTCH, slider.x + 200 * slider.point, slider.y + 64, 1 + slider.takeAnimation + slider.pointMoveAnim, 1 + slider.takeAnimation - slider.pointMoveAnim)

end

function getSliderValue(slider) return slider.point + 0.5 end