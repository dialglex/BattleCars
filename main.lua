require("car")
require("draw")
require("inputs")
require("collision")

function love.load()
	xsize = 1920
	ysize = 1080
	xrealsize = xsize / 2
	yrealsize = ysize / 2
	--for sharp but bad rotating pixels
	love.graphics.setDefaultFilter("nearest", "nearest")

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
	maptileimage = love.graphics.newImage("Images/Map/SandBlock.png")
	maptileimage:setWrap("repeat", "repeat")
	screencanvas = love.graphics.newCanvas(xrealsize, yrealsize)

	shootsound = love.audio.newSource("Sounds/SoundEffects/NormalShoot.wav")

	icon = love.image.newImageData("Images/Guns/CowboyRevolver.png")

	love.window.setMode(xsize, ysize, {display = 1, centered = true, fullscreen = true})
	love.window.setTitle("Weaponized Battle Cars")

	love.mouse.setVisible(false)
	love.mouse.setGrabbed(true)
	setupGame()
end

function love.update(dt)
	world:update(dt)
	for i, car in ipairs(cars) do
		updateCar(car, i)
	end
end

function love.draw()
	love.graphics.setCanvas(screencanvas)
		love.graphics.clear()
		love.graphics.draw(maptileimage, objects.ground.quad, objects.ground.body:getX() - 960 / 2, objects.ground.body:getY() - 150 / 2)
		love.graphics.draw(maptileimage, objects.ceiling.quad, objects.ceiling.body:getX() - 960 / 2, objects.ceiling.body:getY() - 32 / 2)
		love.graphics.draw(maptileimage, objects.leftwall.quad, objects.leftwall.body:getX() - 32 / 2, objects.leftwall.body:getY() - 540 / 2)
		love.graphics.draw(maptileimage, objects.rightwall.quad, objects.rightwall.body:getX() - 32 / 2, objects.rightwall.body:getY() - 540 / 2)
		love.graphics.draw(maptileimage, objects.platform1.quad, objects.platform1.body:getX() - 400 / 2, objects.platform1.body:getY() - 32 / 2)
		love.graphics.draw(maptileimage, objects.platform2.quad, objects.platform2.body:getX() - 400 / 2, objects.platform2.body:getY() - 32 / 2)
		love.graphics.draw(objects.leftramp.mesh, objects.leftramp.body:getX(), objects.leftramp.body:getY())
		love.graphics.draw(objects.rightramp.mesh, objects.rightramp.body:getX(), objects.rightramp.body:getY())
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

	world = love.physics.newWorld(0, 1000, true)
	world:setCallbacks(beginContact, endContact)
	objects = {}

	objects.ground = {}
	objects.ground.type = "ground"
	objects.ground.body = love.physics.newBody(world, 480, 465)
	objects.ground.quad = love.graphics.newQuad(0, 0, 960, 150, 32, 32)
	objects.ground.shape = love.physics.newRectangleShape(960, 150)
	objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape)
	objects.ground.fixture:setUserData(objects.ground)

	objects.ceiling = {}
	objects.ceiling.type = "ceiling"
	objects.ceiling.body = love.physics.newBody(world, 480, 16)
	objects.ceiling.quad = love.graphics.newQuad(0, 0, 960, 32, 32, 32)
	objects.ceiling.shape = love.physics.newRectangleShape(960, 32)
	objects.ceiling.fixture = love.physics.newFixture(objects.ceiling.body, objects.ceiling.shape)
	objects.ceiling.fixture:setUserData(objects.ceiling)

	objects.leftwall = {}
	objects.leftwall.type = "leftwall"
	objects.leftwall.body = love.physics.newBody(world, 16, 270)
	objects.leftwall.quad = love.graphics.newQuad(0, 0, 32, 540, 32, 32)
	objects.leftwall.shape = love.physics.newRectangleShape(32, 540)
	objects.leftwall.fixture = love.physics.newFixture(objects.leftwall.body, objects.leftwall.shape)
	objects.leftwall.fixture:setUserData(objects.leftwall)

	objects.rightwall = {}
	objects.rightwall.type = "rightwall"
	objects.rightwall.body = love.physics.newBody(world, 944, 270)
	objects.rightwall.quad = love.graphics.newQuad(0, 0, 32, 540, 32, 32)
	objects.rightwall.shape = love.physics.newRectangleShape(32, 540)
	objects.rightwall.fixture = love.physics.newFixture(objects.rightwall.body, objects.rightwall.shape)
	objects.rightwall.fixture:setUserData(objects.rightwall)


	objects.platform1 = {}
	objects.platform1.type = "platform1"
	objects.platform1.body = love.physics.newBody(world, 60, 265)
	objects.platform1.quad = love.graphics.newQuad(0, 0, 400, 32, 32, 32)
	objects.platform1.shape = love.physics.newRectangleShape(400, 32)
	objects.platform1.fixture = love.physics.newFixture(objects.platform1.body, objects.platform1.shape)
	objects.platform1.fixture:setUserData(objects.platform1)

	objects.platform2 = {}
	objects.platform2.type = "platform2"
	objects.platform2.body = love.physics.newBody(world, 900, 265)
	objects.platform2.quad = love.graphics.newQuad(0, 0, 400, 32, 32, 32)
	objects.platform2.shape = love.physics.newRectangleShape(400, 32)
	objects.platform2.fixture = love.physics.newFixture(objects.platform2.body, objects.platform2.shape)
	objects.platform2.fixture:setUserData(objects.platform2)

	objects.leftramp = {}
	objects.leftramp.type = "leftramp"
	objects.leftramp.body = love.physics.newBody(world, 177, 390)
	objects.leftramp.meshtable = {{0,0, 0, 1}, {320, -160, 1, 0}, {320, 0, 1, 1}}
	objects.leftramp.mesh = love.graphics.newMesh(objects.leftramp.meshtable)
	objects.leftramp.mesh:setTexture(maptileimage)
	objects.leftramp.shape = love.physics.newPolygonShape(0, 0, 320, -160, 320, 0)
	objects.leftramp.fixture = love.physics.newFixture(objects.leftramp.body, objects.leftramp.shape)
	objects.leftramp.fixture:setUserData(objects.leftramp)

	objects.rightramp = {}
	objects.rightramp.type = "rightramp"
	objects.rightramp.body = love.physics.newBody(world, 497, 390)
	objects.rightramp.meshtable = {{0,-160}, {320, 0}, {0, 0}}
	objects.rightramp.mesh = love.graphics.newMesh(objects.rightramp.meshtable)
	objects.rightramp.mesh:setTexture(maptileimage)
	objects.rightramp.shape = love.physics.newPolygonShape(0, -160, 300, 0, 0, 0)
	objects.rightramp.fixture = love.physics.newFixture(objects.rightramp.body, objects.rightramp.shape)
	objects.rightramp.fixture:setUserData(objects.rightramp)

	table.insert(cars, createCar(0))
	for i, gamepad in ipairs(gamepads) do
		table.insert(cars, createCar(i))
	end
end