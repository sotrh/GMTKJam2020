extends KinematicBody2D

export(int) var gravity = 1200
export(int) var move_speed = 200
export(int) var jump_speed = 600
export(int) var friction = 1.0

enum State {
	Ball
	Cube
	Spring
}
export(State) var state

const UP = Vector2(0, -1)

onready var ball_shape = $BallShape
onready var box_shape = $BoxShape
onready var spring_shape = $SpringShape

var velocity = Vector2.ZERO

func get_horizontal_axis():
	return Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

func process_ball():
	ball_shape.disabled = false
	box_shape.disabled = true
	spring_shape.disabled = true
	var movement = Vector2.ZERO
	movement.x = get_horizontal_axis() * move_speed
	if Input.is_action_just_pressed("jump") and is_on_floor():
		movement.y = -jump_speed
	return movement
	
func process_cube():
	ball_shape.disabled = true
	box_shape.disabled = false
	spring_shape.disabled = true
	return Vector2.ZERO
	
func process_spring():
	ball_shape.disabled = true
	box_shape.disabled = true
	spring_shape.disabled = false
	var jump_just_presssed = Input.is_action_just_pressed("jump")
	var mouse_pos = get_global_mouse_position()
	var facing = mouse_pos - global_position
	rotation = -atan(facing.x / facing.y)
	
	var movement = Vector2.ZERO
	if jump_just_presssed and is_on_floor():
		movement = facing.normalized() * jump_speed
	return movement

func _physics_process(delta):
	rotation = 0
	var movement = Vector2.ZERO
	match state:
		State.Ball:
			movement = process_ball()
		State.Cube:
			movement = process_cube()
		State.Spring:
			movement = process_spring()
	
	velocity.y += gravity * delta * (2 if velocity.y > 0 else 1)
	velocity += movement
	velocity = move_and_slide(velocity, UP)
	
	if is_on_floor():
		velocity.x = lerp(velocity.x, 0, friction)
		if velocity.y > 0:
			velocity.y = gravity * delta
