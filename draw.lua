function drawCar(car)
	love.graphics.setColor(255, 255, 255)
	if car.primaryshoot then
		if car.flip == false then
			love.graphics.draw(car.canvas, car.body:getX(), car.body:getY(), car.body:getAngle(), 1, 1, car.image:getWidth() / 2, car.image:getHeight() / 2 + car.primarygunimage:getHeight())
		else
			love.graphics.draw(car.canvas, car.body:getX(), car.body:getY(), car.body:getAngle(), -1, 1, car.image:getWidth() / 2, car.image:getHeight() / 2 + car.primarygunimage:getHeight())
		end
	elseif car.secondaryshoot then
		if car.flip == false then
			love.graphics.draw(car.canvas, car.body:getX(), car.body:getY(), car.body:getAngle(), 1, 1, car.image:getWidth() / 2, car.image:getHeight() / 2 + car.secondarygunimage:getHeight())
		else
			love.graphics.draw(car.canvas, car.body:getX(), car.body:getY(), car.body:getAngle(), -1, 1, car.image:getWidth() / 2, car.image:getHeight() / 2 + car.secondarygunimage:getHeight())
		end
	end

	if car.primaryshoot and car.firecounter < 5 then
		love.graphics.draw(car.primarygunfireeffect, car.fireX, car.fireY, car.body:getAngle())
		car.firecounter = car.firecounter + 1
	end

	if car.secondaryshoot and car.firecounter < 5 then
		love.graphics.draw(car.secondarygunfireeffect, car.fireX, car.fireY, car.body:getAngle())
		car.firecounter = car.firecounter + 1
	end

	for i, v in ipairs(car.primarygunbullets) do
		love.graphics.draw(car.primarygunbulletimage, v.body:getX(), v.body:getY(), v.angle)
	end
	for i, v in ipairs(car.secondarygunbullets) do
		love.graphics.draw(car.secondarygunbulletimage, v.x, v.y, v.angle)
	end
end

function drawArmour(car)
	love.graphics.setColor(255, 255, 255)
	if car.hp > 80 then
		if car.armourcolour == "blue" then
			armourimage = bluearmourimage1
		elseif car.armourcolour == "red" then
			armourimage = redarmourimage1
		elseif car.armourcolour == "green" then
			armourimage = greenarmourimage1
		else
			armourimage = orangearmourimage1
		end
	elseif car.hp > 60 and car.hp <= 80 then
		if car.armourcolour == "blue" then
			armourimage = bluearmourimage2
		elseif car.armourcolour == "red" then
			armourimage = redarmourimage2
		elseif car.armourcolour == "green" then
			armourimage = greenarmourimage2
		else
			armourimage = orangearmourimage2
		end
	elseif car.hp > 40 and car.hp <= 60 then
		if car.armourcolour == "blue" then
			armourimage = bluearmourimage3
		elseif car.armourcolour == "red" then
			armourimage = redarmourimage3
		elseif car.armourcolour == "green" then
			armourimage = greenarmourimage3
		else
			armourimage = orangearmourimage3
		end
	elseif car.hp > 20 and car.hp <= 40 then
		if car.armourcolour == "blue" then
			armourimage = bluearmourimage4
		elseif car.armourcolour == "red" then
			armourimage = redarmourimage4
		elseif car.armourcolour == "green" then
			armourimage = greenarmourimage4
		else
			armourimage = orangearmourimage4
		end
	else
		if car.armourcolour == "blue" then
			armourimage = bluearmourimage5
		elseif car.armourcolour == "red" then
			armourimage = redarmourimage5
		elseif car.armourcolour == "green" then
			armourimage = greenarmourimage5
		else
			armourimage = orangearmourimage5
		end
	end

	love.graphics.draw(armourimage, car.armourX, car.armourY)

	love.graphics.setFont(armourfont)
	love.graphics.printf(car.hp .. "%", car.armourX + 13, car.armourY + 45, 72, "center")
end

function drawCrosshair(car)
	love.graphics.draw(car.crosshairimage, math.floor(car.inputs.crosshairX - car.crosshairimage:getWidth() / 2), math.floor(car.inputs.crosshairY - car.crosshairimage:getHeight() / 2))
end