function beginContact(fixture1, fixture2, contact)
	local entity1 = fixture1:getUserData()
	local entity2 = fixture2:getUserData()
	if entity1.type == "car" and isGround(entity2) then
		beginCarCollision(entity1)
	elseif isGround(entity1) and entity2.type == "car" then
		beginCarCollision(entity2)
	end
	if entity1.type == "bullet" and entity2.type == "car" then
		beginBulletCollision(entity2)
	elseif entity1.type == "car" and entity2.type == "bullet" then
		beginBulletCollision(entity1)
	end
end

function endContact(fixture1, fixture2, contact)
	local entity1 = fixture1:getUserData()
	local entity2 = fixture2:getUserData()
	if entity1.type == "car" and isGround(entity2) then
		endCarCollision(entity1)
	elseif isGround(entity1) and entity2.type == "car" then
		endCarCollision(entity2)
	end
end

function beginCarCollision(car)
	car.grounded = true
end

function endCarCollision(car)
	car.grounded = false
end

function beginBulletCollision(car)
	car.hit = true
	print("kappa")
end

function isGround(entity)
	return entity.type == "ground" or entity.type == "leftramp" or entity.type == "rightramp" or entity.type == "platform1" or entity.type == "platform2" or entity.type == "car"
end