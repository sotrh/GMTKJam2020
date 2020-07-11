extends KinematicBody2D

export (int) var gravity = 1200
export (int) var move_speed = 400
export (int) var jump_speed = 600

const UP = Vector2(0, -1)

var velocity = Vector2.ZERO

func _physics_process(delta):
	var movement = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	velocity.x = movement * move_speed
	velocity.y += gravity * delta * (2 if velocity.y > 0 else 1)
	velocity = move_and_slide(velocity, UP)
	
	if Input.is_action_just_pressed("jump"):
		print("Jump")
		if is_on_floor():
			print("-> ", is_on_floor())
			velocity.y = -jump_speed
	
	if is_on_floor() and velocity.y > 0:
		velocity.y = gravity * delta
