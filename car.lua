function createCarCanvas(car)
	local canvas = love.graphics.newCanvas(car.image:getWidth(), car.image:getHeight() + car.secondarygunimage:getHeight())
	love.graphics.setCanvas(canvas)
	if car.primaryshoot then
		love.graphics.draw(car.image, 0, car.primarygunimage:getHeight())
		love.graphics.draw(car.primarygunimage, car.image:getWidth() / 2 - 8, 0)
	elseif car.secondaryshoot then
		love.graphics.draw(car.image, 0, car.secondarygunimage:getHeight())
		love.graphics.draw(car.secondarygunimage, car.image:getWidth() / 2 - 8, 0)
	end
    love.graphics.setCanvas()
    return canvas
end

function createCar(inputsource)
	local car = {}

	if inputsource == 0 then
		car.x = 192
		car.image = bluecarimage
		car.crosshairimage = crosshairimage3
		car.armourX = 25
		car.armourY = 397
		car.armourcolour = "blue"
	elseif inputsource == 1 then
		car.x = 768
		car.image = redcarimage
		car.crosshairimage = crosshairimage4
		car.armourX = 839
		car.armourY = 397
		car.armourcolour = "red"
	elseif inputsource == 2 then
		car.x = 384
		car.image = greencarimage
		car.crosshairimage = crosshairimage2
		car.armourX = 25
		car.armourY = 25
		car.armourcolour = "green"
	else
		car.x = 576
		car.image = orangecarimage
		car.crosshairimage = crosshairimage1
		car.armourX = 839
		car.armourY = 25
		car.armourcolour = "orange"
	end

	car.primarygunfireeffect = basicfireeffect
	car.primarygunbulletimage = basicbulletimage
	car.primarygunimage = cowboyrevolverimage
	car.primarygunfirerate = 15
	car.primarygundamage = 3
	car.primarygunbulletspeed = 25
	car.primarygunbullets = {}

	car.secondarygunfireeffect = laserfireeffect
	car.secondarygunbulletimage = laserbulletimage
	car.secondarygunimage = lasergunimage
	car.secondarygunfirerate = 10
	car.secondarygundamage = 2
	car.secondarygunbulletspeed = 15
	car.secondarygunbullets = {}
	
	car.movementabilitycooldown = 0

	car.lastgunusedimage = cowboyrevolverimage
	car.y = screencanvas:getHeight() / 2 - car.image:getHeight() / 2
	car.gunrotation = 0
	car.yvelocity = 0
	car.xvelocity = 0
	car.grounded = true
	car.jumpcounter = 0
	car.rotationcounter = 0
	car.rotation = 0
	car.fire = false
	car.firecounter = 0
	car.fireXoffset = car.primarygunimage:getWidth() - 8
	car.fireYoffset = -21
	car.bulletcounter = 0
	car.inputsource = inputsource
	car.canvas = createCarCanvas(car)
	car.oldaxisX = 0
	car.oldaxisY = 0
	car.hp = 100
	car.primaryshoot = true
	car.secondaryshoot = false
	car.explosioncounter = 0

	car.inputs = {}
	car.inputs.crosshairX = 0
	car.inputs.crosshairY = 0

	return car
end

function updateCar(car, carindex)
	car.inputs = getInput(car)

	if car.primaryshoot then
		car.fireXoffset = car.primarygunimage:getWidth() - 8
	elseif car.secondaryshoot then
		car.fireXoffset = car.secondarygunimage:getWidth() - 8
	end

	car.fireX = car.x + car.fireXoffset
	car.fireY = car.y + car.fireYoffset

	if car.inputs.restart then
		setupGame()
	end

	if car.y >= screencanvas:getHeight() / 2 - car.image:getHeight() / 2 then
		car.grounded = true
		car.jumpcounter = 0
		car.y = screencanvas:getHeight() / 2 - car.image:getHeight() / 2
	else
		car.grounded = false
	end

    if car.grounded == true then
		if car.inputs.left then
			car.xvelocity = -3
		elseif car.inputs.right then
			car.xvelocity = 3
		else
			car.xvelocity = 0
		end
		car.yvelocity = 0
	else
		if car.inputs.left then
			car.rotation = car.rotation - 0.1163168189
		elseif car.inputs.right then
			car.rotation = car.rotation + 0.1163168189
		end
	end
	if car.inputs.jump and car.grounded == true then
		car.yvelocity = 5
		grounded = false
		print("kappa")
	end
	print(car.yvelocity)

	if car.grounded == false then
		car.y = car.y - car.yvelocity
		car.jumpcounter = car.jumpcounter + 1
		if car.jumpcounter == 5 then
			car.yvelocity = car.yvelocity - 1
			car.jumpcounter = 0
		end
	end

	if car.inputs.primaryfire then
		car.primaryshoot = true
		car.secondaryshoot = false
		car.firecounter = 0

		local angle = math.atan2((car.inputs.crosshairY - car.fireY), (car.inputs.crosshairX - car.fireX))

		local bulletDx = car.primarygunbulletspeed * math.cos(angle)
		local bulletDy = car.primarygunbulletspeed * math.sin(angle)

		table.insert(car.primarygunbullets, {x = car.fireX, y = car.fireY, dx = bulletDx, dy = bulletDy, angle = angle})

		car.bulletcounter = 0
	elseif car.bulletcounter < car.primarygunfirerate then
		car.bulletcounter = car.bulletcounter + 1
	end

	if car.inputs.secondaryfire then
		car.secondaryshoot = true
		car.primaryshoot = false
		car.firecounter = 0

		local angle = math.atan2((car.inputs.crosshairY - car.fireY), (car.inputs.crosshairX - car.fireX))

		local bulletDx = car.secondarygunbulletspeed * math.cos(angle)
		local bulletDy = car.secondarygunbulletspeed * math.sin(angle)

		table.insert(car.secondarygunbullets, {x = car.fireX, y = car.fireY, dx = bulletDx, dy = bulletDy, angle = angle})

		car.bulletcounter = 0
	elseif car.bulletcounter < car.secondarygunfirerate then
		car.bulletcounter = car.bulletcounter + 1
	end

	if car.inputs.movementability then
		local angle = math.atan2((car.inputs.crosshairY - car.fireY), (car.inputs.crosshairX - car.fireX))
		car.x = car.x + math.cos(angle) * 200
		car.y = car.y + math.sin(angle) * 200
		car.movementabilitycooldown = 60*1
	elseif car.movementabilitycooldown > 0 then
		car.movementabilitycooldown = car.movementabilitycooldown - 1
	end
 
	car.x = car.x + car.xvelocity
	if car.x > 960 - car.image:getWidth() / 2 then
		car.x = 960 - car.image:getWidth() / 2
	elseif car.x < 0 + car.image:getWidth() / 2 then
		car.x = 0 + car.image:getWidth() / 2 
	end

	for i, bullet in ipairs(car.primarygunbullets) do
		bullet.x = bullet.x + bullet.dx
		bullet.y = bullet.y + bullet.dy
		if bullet.x > xrealsize or bullet.x < 0 or bullet.y > yrealsize / 2 or bullet.y < 0 then
			table.remove(car.primarygunbullets, i)
		end
	end

	for i, bullet in ipairs(car.secondarygunbullets) do
		bullet.x = bullet.x + bullet.dx
		bullet.y = bullet.y + bullet.dy
		if bullet.x > xrealsize or bullet.x < 0 or bullet.y > yrealsize / 2 or bullet.y < 0 then
			table.remove(car.secondarygunbullets, i)
		end
	end

	bulletCollision(car)

	if car.hp <= 0 then
		table.remove(cars, carindex)
	end

	car.canvas = createCarCanvas(car)
end

function bulletCollision(car)
	for i, othercar in ipairs(getOtherCars(car.inputsource)) do
		local hitboxX1 = othercar.x - othercar.image:getWidth() / 2
		local hitboxY1 = othercar.y - othercar.image:getHeight() / 2
		local hitboxX2 = othercar.x + othercar.image:getWidth() / 2
		local hitboxY2 = othercar.y + othercar.image:getHeight() / 2
		for i, bullet in ipairs(car.primarygunbullets) do
			if bullet.x >= hitboxX1 and bullet.x <= hitboxX2 and bullet.y >= hitboxY1 and bullet.y <= hitboxY2 then
				othercar.hp = othercar.hp - car.primarygundamage
				table.remove(car.primarygunbullets, i)
			end
		end
		for i, bullet in ipairs(car.secondarygunbullets) do
			if bullet.x >= hitboxX1 and bullet.x <= hitboxX2 and bullet.y >= hitboxY1 and bullet.y <= hitboxY2 then
				othercar.hp = othercar.hp - car.secondarygundamage
				table.remove(car.secondarygunbullets, i)
			end
		end
	end
end

function getOtherCars(inputsource)
	local otherCars = {}
	for i, car in ipairs(cars) do
		if car.inputsource ~= inputsource then
			table.insert(otherCars, car)
		end
	end
	return otherCars
end