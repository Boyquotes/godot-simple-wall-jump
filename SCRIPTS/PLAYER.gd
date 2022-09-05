extends KinematicBody

onready var head: Spatial = $HEAD

export var speed        : float = 10 # player walk speed
export var gravity      : float = 50
export var jump_force   : float = 20
export var ground_accel : float = 8
export var air_accel    : float = 2
export var friction     : float = 0.25

var dir : Vector3 # direction
var vel : Vector3 # velocity


func _process(delta):
	dir.x = Input.get_action_strength("LEFT") - Input.get_action_strength("RIGHT")
	dir.z = Input.get_action_strength("FORWARD") - Input.get_action_strength("BACKWARD")
	dir = dir.rotated(Vector3.UP, head.rotation.y).normalized()


func _physics_process(delta):
	grav(delta)
	jump(delta)
	move(delta)


func grav(delta):
	vel.y -= gravity * delta
	vel = move_and_slide(vel, Vector3.UP)


func move(delta): # just walking
	if is_on_floor():
		if dir.x != 0 or dir.z != 0:
			vel.x = lerp(vel.x, dir.x * speed, ground_accel * delta)
			vel.z = lerp(vel.z, dir.z * speed, ground_accel * delta)
		else:
			vel.x = lerp(vel.x, 0, friction)
			vel.z = lerp(vel.z, 0, friction)
	else:
		if dir.x != 0 or dir.z != 0:
			vel.x = lerp(vel.x, dir.x * speed, air_accel * delta)
			vel.z = lerp(vel.z, dir.z * speed, air_accel * delta)


func jump(delta):
	if is_on_floor(): # jumping when player is on the ground
		if Input.is_action_just_pressed("JUMP"):
			vel.y = jump_force
	else:
		if is_on_wall(): # jumping when the player is not on the ground and is on the wall
			if Input.is_action_just_pressed("JUMP"):
				if get_slide_collision(0) != null: # to avoid bugs
					vel.y = jump_force
					vel.x = vel.x + get_slide_collision(0).normal.x * jump_force
					vel.z = vel.z + get_slide_collision(0).normal.z * jump_force
