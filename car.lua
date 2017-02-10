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
	car.type = "car"
	car.body = love.physics.newBody(world, 0, 0, "dynamic")
	car.shape = love.physics.newRectangleShape(56, 26)
	car.fixture = love.physics.newFixture(car.body, car.shape, 1)
	car.fixture:setUserData(car)

	if inputsource == 0 then
		car.body:setX(192)
		car.body:setY(237)
		car.image = bluecarimage
		car.crosshairimage = crosshairimage3
		car.armourX = 10
		car.armourY = 407
		car.armourcolour = "blue"
		car.flip = false
	elseif inputsource == 1 then
		car.body:setX(768)
		car.body:setY(237)
		car.image = redcarimage
		car.crosshairimage = crosshairimage4
		car.armourX = 849
		car.armourY = 407
		car.armourcolour = "red"
		car.flip = true
	elseif inputsource == 2 then
		car.body:setX(384)
		car.body:setY(237)
		car.image = greencarimage
		car.crosshairimage = crosshairimage2
		car.armourX = 10
		car.armourY = 10
		car.armourcolour = "green"
		car.flip = false
	else
		car.body:setX(576)
		car.body:setY(237)
		car.image = orangecarimage
		car.crosshairimage = crosshairimage1
		car.armourX = 849
		car.armourY = 10
		car.armourcolour = "orange"
		car.flip = true
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

	car.fireX = car.body:getX() + car.fireXoffset
	car.fireY = car.body:getY() + car.fireYoffset

	if car.inputs.restart then
		setupGame()
	end

	if car.inputs.left then
		car.body:applyForce(-1500, 0)
	elseif car.inputs.right then
		car.body:applyForce(1500, 0)
	end

	if car.inputs.jump and car.grounded then
		car.body:applyLinearImpulse(0, -350)
	end

	if car.inputs.primaryfire then
		car.primaryshoot = true
		car.secondaryshoot = false
		car.firecounter = 0

		local angle = math.atan2((car.inputs.crosshairY - car.fireY), (car.inputs.crosshairX - car.fireX))

		local bulletDx = car.primarygunbulletspeed * math.cos(angle)
		local bulletDy = car.primarygunbulletspeed * math.sin(angle)

		table.insert(car.primarygunbullets, {body = love.physics.newBody(world, car.fireX, car.fireY, "dynamic", 0), shape = love.physics.newRectangleShape(15, 5), dx = bulletDx, dy = bulletDy, angle = angle, remove = false})
		for i, bullet in ipairs(car.primarygunbullets) do
			car.primarygunbullets.type = "bullet"
			bullet.body:setGravityScale(0)
			bullet.fixture = love.physics.newFixture(bullet.body, bullet.shape, 0)
			bullet.fixture:setUserData(car.primarygunbullets)
			bullet.body:setBullet("true")
		end
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

	for i, bullet in ipairs(car.primarygunbullets) do
		bullet.body:applyLinearImpulse(bullet.dx * 100, bullet.dy * 100)
		for i, othercar in ipairs(getOtherCars(car.inputsource)) do
			if othercar.hit then
				othercar.hp = othercar.hp - car.primarygundamage
				table.remove(car.primarygunbullets, i)
			end
		end
	end

	for i, bullet in ipairs(car.secondarygunbullets) do
		bullet.x = bullet.x + bullet.dx
		bullet.y = bullet.y + bullet.dy
	end

	if car.hp <= 0 then
		table.remove(cars, carindex)
	end

	car.canvas = createCarCanvas(car)
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