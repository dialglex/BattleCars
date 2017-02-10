function getGamepadInputs(car)
	local inputs = {}
	gamepad = gamepads[car.inputsource]
	local axisX = gamepad:getGamepadAxis("rightx")
	local axisY = gamepad:getGamepadAxis("righty")
	if math.abs(axisX) < 0.3 and math.abs(axisY) < 0.3 then
		axisX = car.oldaxisX
		axisY = car.oldaxisY
	else
		car.oldaxisX = gamepad:getGamepadAxis("rightx")
		car.oldaxisY = gamepad:getGamepadAxis("righty")
	end

	local angle = math.atan2(axisY, axisX)

	inputs.crosshairX = car.body:getX() + car.fireXoffset + math.cos(angle) * 100
	inputs.crosshairY = car.body:getY() + car.fireYoffset + math.sin(angle) * 100

    if gamepad:isGamepadDown("leftshoulder") then
    	inputs.jump = true
    end
    if gamepad:getGamepadAxis("leftx") < -0.8 then
    	inputs.left = true
    elseif gamepad:getGamepadAxis("leftx") > 0.8 then
    	inputs.right = true
    end
    if gamepad:getGamepadAxis("triggerleft") > 0.8 and car.bulletcounter >= car.primarygunfirerate then
		inputs.primaryfire = true
	end
	if gamepad:getGamepadAxis("triggerright") > 0.8 and car.bulletcounter >= car.secondarygunfirerate then
		inputs.secondaryfire = true
	end
	if gamepad:isGamepadDown("a") and car.movementabilitycooldown <= 0 then
		inputs.movementability = true
	end
	if gamepad:isGamepadDown("back") then
		inputs.restart = true
	end

    return inputs
end

function getKeyboardInputs(car)
	local inputs = {}
    if love.keyboard.isDown("space") then
    	inputs.jump = true
    end
	if love.keyboard.isDown("a") then
		inputs.left = true
	elseif love.keyboard.isDown("d") then
		inputs.right = true
	end
	if love.mouse.isDown(1) and car.bulletcounter >= car.primarygunfirerate then
		inputs.primaryfire = true
	end
	if love.mouse.isDown(2) and car.bulletcounter >= car.secondarygunfirerate then
		inputs.secondaryfire = true
	end
	if love.mouse.isDown(3) and car.movementabilitycooldown <= 0 then
		inputs.movementability = true
	end

	if love.keyboard.isDown("escape") then
		inputs.restart = true
	end

	inputs.crosshairX = love.mouse.getX() / 2
	inputs.crosshairY = love.mouse.getY() / 2

	return inputs
end

function getInput(car)
	if car.inputsource == 0 then
		return getKeyboardInputs(car)
	end

	return getGamepadInputs(car)
end