require("car")
require("draw")
require("inputs")

function love.load()
	xsize = 1920
	ysize = 1080
	xrealsize = xsize / 2
	yrealsize = ysize / 2
	--for sharp but bad rotating pixels
	--love.graphics.setDefaultFilter("nearest", "nearest")

	love.graphics.setBackgroundColor(255, 255, 255)

	bluecarimage = love.graphics.newImage("Images/Cars/TakumiBlue.png")
	redcarimage = love.graphics.newImage("Images/Cars/TakumiRed.png")
	greencarimage = love.graphics.newImage("Images/Cars/TakumiGreen.png")
	orangecarimage = love.graphics.newImage("Images/Cars/TakumiOrange.png")
	cowboyrevolverimage = love.graphics.newImage("Images/Guns/CowboyRevolver.png")
	lasergunimage = love.graphics.newImage("Images/Guns/LaserGun.png")
	crosshairimage1 = love.graphics.newImage("Images/UI/Mouse/Crosshair1.png")
	crosshairimage2 = love.graphics.newImage("Images/UI/Mouse/Crosshair2.png")
	crosshairimage3 = love.graphics.newImage("Images/UI/Mouse/Crosshair3.png")
	crosshairimage4 = love.graphics.newImage("Images/UI/Mouse/Crosshair4.png")
	bluearmourimage1 = love.graphics.newImage("Images/UI/Armour/ArmourBlue1.png")
	bluearmourimage2 = love.graphics.newImage("Images/UI/Armour/ArmourBlue2.png")
	bluearmourimage3 = love.graphics.newImage("Images/UI/Armour/ArmourBlue3.png")
	bluearmourimage4 = love.graphics.newImage("Images/UI/Armour/ArmourBlue4.png")
	bluearmourimage5 = love.graphics.newImage("Images/UI/Armour/ArmourBlue5.png")
	redarmourimage1 = love.graphics.newImage("Images/UI/Armour/ArmourRed1.png")
	redarmourimage2 = love.graphics.newImage("Images/UI/Armour/ArmourRed2.png")
	redarmourimage3 = love.graphics.newImage("Images/UI/Armour/ArmourRed3.png")
	redarmourimage4 = love.graphics.newImage("Images/UI/Armour/ArmourRed4.png")
	redarmourimage5 = love.graphics.newImage("Images/UI/Armour/ArmourRed5.png")
	greenarmourimage1 = love.graphics.newImage("Images/UI/Armour/ArmourGreen1.png")
	greenarmourimage2 = love.graphics.newImage("Images/UI/Armour/ArmourGreen2.png")
	greenarmourimage3 = love.graphics.newImage("Images/UI/Armour/ArmourGreen3.png")
	greenarmourimage4 = love.graphics.newImage("Images/UI/Armour/ArmourGreen4.png")
	greenarmourimage5 = love.graphics.newImage("Images/UI/Armour/ArmourGreen5.png")
	orangearmourimage1 = love.graphics.newImage("Images/UI/Armour/ArmourOrange1.png")
	orangearmourimage2 = love.graphics.newImage("Images/UI/Armour/ArmourOrange2.png")
	orangearmourimage3 = love.graphics.newImage("Images/UI/Armour/ArmourOrange3.png")
	orangearmourimage4 = love.graphics.newImage("Images/UI/Armour/ArmourOrange4.png")
	orangearmourimage5 = love.graphics.newImage("Images/UI/Armour/ArmourOrange5.png")
	basicbulletimage = love.graphics.newImage("Images/Bullets/BasicBullet.png")
	laserbulletimage = love.graphics.newImage("Images/Bullets/Laser.png")
	basicfireeffect = love.graphics.newImage("Images/Bullets/BasicEffect.png")
	laserfireeffect = love.graphics.newImage("Images/Bullets/LaserEffect.png")
	armourfont = love.graphics.newImageFont("Images/Fonts/ArmourFont.png", "0123456789.-%")
	announcerfont = love.graphics.newImageFont("Images/Fonts/AnnouncerFont.png", "")
	textfont = love.graphics.newImageFont("Images/Fonts/TextFont.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!/-+/():;%&`'{}|~$@^_<>") --bugs out with \
	explosionimage = love.graphics.newImage("Images/FX/Explosion.png")
	movementabilityicon = love.graphics.newImage("Images/UI/Abilities/MovementAbility.png")
	screencanvas = love.graphics.newCanvas(xrealsize, yrealsize)

	world = love.physics.newWorld(0, 1000, true)
	objects = {}

	objects.ground = {}
	objects.ground.body = love.physics.newBody(world, screencanvas:getWidth() - screencanvas:getWidth() / 2, screencanvas:getHeight() - screencanvas:getHeight() / 4)
	objects.ground.shape = love.physics.newRectangleShape(screencanvas:getWidth(), screencanvas:getHeight() / 2)
	objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape)

	shootsound = love.audio.newSource("Sounds/SoundEffects/NormalShoot.wav")

	icon = love.image.newImageData("Images/Guns/CowboyRevolver.png")

	love.window.setMode(xsize, ysize, {display = 1, centered = true, fullscreen = true})
	love.window.setTitle("Weaponized Battle Cars")

	love.mouse.setVisible(false)
	love.mouse.setGrabbed(true)

	setupGame()
end

function love.update()
	for i, car in ipairs(cars) do
		updateCar(car, i)
	end
end

function love.draw()
	love.graphics.setCanvas(screencanvas)
		love.graphics.clear()
		love.graphics.setColor(239, 221, 111)
		love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape:getPoints()))
		for i, car in ipairs(cars) do
			drawArmour(car)
			drawCar(car)
		end
		for i, car in ipairs(cars) do
			drawCrosshair(car)
		end
		love.graphics.setFont(textfont)
		love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
    love.graphics.setCanvas()

    love.graphics.draw(screencanvas, 0, 0, 0, 2, 2)
end

function setupGame()
	cars = {}
	gamepads = love.joystick.getJoysticks()

	table.insert(cars, createCar(0))
	for i, gamepad in ipairs(gamepads) do
		table.insert(cars, createCar(i))
	end
end