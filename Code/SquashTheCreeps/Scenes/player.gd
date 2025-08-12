extends CharacterBody3D

# ***NOTE*** Throughout this player script (below) we have included extensive notes from the tutorial so that we can reference later when dissecting and trying to better understand all these functions.

# To begin our Player script, on lines 6, 8, and 10, we will start with the class's properties. We're going to define a movement speed, a fall acceleration representing gravity, and a velocity we'll use to move the character.

# How fast the player moves in meters per second.
@export var speed = 14
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75
# Vertical impulse applied to the character upon jumping in meters per second.
@export var jump_impulse = 20
# Vertical impulse applied to the character up on bouncing over a mob in meters per second.
@export var bounce_impulse = 16

var target_velocity = Vector3.ZERO

# Above, these are common properties for a moving body. The target_velocity is a 3D Vector combining a speed with a direction. Here, we define it as a property because we want to update and reuse its value across frames.

# ***NOTE: The values are quite different from 2D code because distances are in meters. While in 2D, a thousand units (pixels) may only correspond to half of your screen's width, in 3D it's a kilometer. ***  

# Next, in the lines below, we will code the movement. We start by calculating the inpuyt direction vector using the global 'Input' object, in _physics_process().
func _physics_process(delta):
	# We create a local variable to store the input direction.
	var direction = Vector3.ZERO 
	
	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
		
	# Here, instead of _process(), we're going to make all calculations using the _physics_process() virtual function. It's designed specifically for physics-related code like moving a kinematic or rigid body. It updates the node using fixed time intervals.  To learn more, see IDLE AND PHYSICS PROCESSING in the Godot Docs.
	
	# We start by initializing a 'direction' variable to Vector3.ZERO. Then, we check if the player is pressing one or more of the move_* inputs and update the vector's x and y components accordingly. These correspond to the ground plane's axes.
	
	# These four conditions give us eight possiblities and eight possible directions.
	
	# In case the player presses, say, both W and D simultaneously, the vector will have a length of about 1.4. But if they press a single key, it will have a length of 1. We want the vector's length to be consistent, and not move faster diagonally. To do so, we can call its normalized() method.
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		# Setting the basis property will affect the rotation of the node.
		$Pivot.basis = Basis.looking_at(direction)
		
	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity.
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
		
	# Moving the Character
	velocity = target_velocity
	# Jumping.
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
	move_and_slide()
	
	#Iterate through all collisions that occurred this frame.
	for index in range(get_slide_collision_count()):
		# We get one of the collisions with the player.
		var collision = get_slide_collision(index)
		
		# If there are duplicate collisions with a mob in a single frame, the mob will be deleted after the first collision, and a second call to get_collider will return null, leading to a null pointer when calling collision.get_collider().is_in_group("mob").  
		# TODO: Figure out, what is a null pointer???
		# This block of code prevents processing duplicate collisions.
		if collision.get_collider() == null:
			continue
			
		# If the collider is with a mob
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
			# We check that we are hitting it from above.
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				# If so, we squash it and bounce.
				mob.squash()
				target_velocity.y = bounce_impulse
				# Prevent further duplicate calls.
				break
	# NOTE: The functions get_slide_collision_count() and get_slide_collision() both come from the CharacterBody3D class and are related to move_and_slide().
	# get_slide_collision() returns a KinematicCollision3D object that holds information about where and how the collision occurred. For example, we use its get_collider property to check if we collided with a "mob" by calling is_in_group() on it: collision.get_collider().is_in_group("mob").
	
	# To check that we are landing on the monster, we use the vector dot product: Vector3.UP.dot(collision.get_normal()) > 0.1. The collision normal is a 3D vector that is perpendicular to the plane where the collision occurred. The dot product allows us to compare it to the up direction.

 	# With dot products, when the result is greater than 0, the two vectors are at an angle of fewer than 90 degrees. A value higher than 0.1 tells us that we are roughly above the monster.

	# After handling the squash and bounce logic, we terminate the loop early via the break statement to prevent further duplicate calls to mob.squash(), which may otherwise result in unintended bugs such as counting the score multiple times for one kill.
	
	# NOTE: The CharacterBody3D.is_on_floor() function returns true if the body collided with the floor in this frame. That's why we apply gravity to the Player only while it is in the air.

	# For the vertical velocity, we subtract the fall acceleration multiplied by the delta time every frame. This line of code will cause our character to fall in every frame, as long as it is not on or colliding with the floor.

	# The physics engine can only detect interactions with walls, the floor, or other bodies during a given frame if movement and collisions happen. We will use this property later to code the jump.

	# On the last line, we call CharacterBody3D.move_and_slide() which is a powerful method of the CharacterBody3D class that allows you to move a character smoothly. If it hits a wall midway through a motion, the engine will try to smooth it out for you. It uses the velocity value native to the CharacterBody3D

	# And that's all the code you need to move the character on the floor.
			
	
