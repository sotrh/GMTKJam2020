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

onready var animated_sprite = $AnimatedSprite
onready var ball_shape = $BallShape
onready var box_shape = $BoxShape
onready var spring_shape = $SpringShape
onready var grunt = $GruntSound
onready var boing = $BoingSound
onready var anvil = $AnvilSound
onready var ball_sound = $BallSound

var velocity = Vector2.ZERO
var frames_on_ground = 0

func get_horizontal_axis():
	return Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

func process_ball():
	ball_shape.disabled = false
	box_shape.disabled = true
	spring_shape.disabled = true
	var movement = Vector2.ZERO
	movement.x = get_horizontal_axis() * move_speed
	if Input.is_action_just_pressed("jump") and is_on_floor():
		ball_sound.play()
		movement.y = -jump_speed
	
	if movement.x < 0:
		animated_sprite.play("ball_roll_left")
	elif movement.x > 0:
		animated_sprite.play("ball_roll_right")
	else:
		animated_sprite.play("ball_idle")
	
	return movement
	
func process_cube():
	if is_on_floor():
		if frames_on_ground == 0:
			anvil.play()
		frames_on_ground += 1
	else:
		frames_on_ground = 0
		
	ball_shape.disabled = true
	box_shape.disabled = false
	spring_shape.disabled = true
	animated_sprite.play("not_the_weight!")
	if Input.is_action_just_pressed("jump")\
		or Input.is_action_just_pressed("ui_left")\
		or Input.is_action_just_pressed("ui_right"):
		grunt.play()
	return Vector2.ZERO
	
func process_spring():
	ball_shape.disabled = true
	box_shape.disabled = true
	spring_shape.disabled = false
	var jump_just_presssed = Input.is_action_just_pressed("jump")
	var mouse_pos = get_global_mouse_position()
	var facing = mouse_pos - global_position
	rotation = -atan(facing.x / facing.y)
	
	if mouse_pos.x < 0:
		animated_sprite.play("spring_left")
	elif mouse_pos.x > 0:
		animated_sprite.play("spring_right")
	else:
		animated_sprite.play("spring_idle")
		
	
	var movement = Vector2.ZERO
	if jump_just_presssed:
		if is_on_floor():
			movement = facing.normalized() * jump_speed
			boing.play()
	return movement

func _physics_process(delta):
	rotation = 0
	var movement = Vector2.ZERO
	var is_ball = false
	match state:
		State.Ball:
			movement = process_ball()
			is_ball = true
		State.Cube:
			movement = process_cube()
		State.Spring:
			movement = process_spring()
	
	velocity.y += gravity * delta * (2 if velocity.y > 0 else 1)
	if is_ball:
		velocity.x = movement.x
		velocity.y += movement.y
	else:
		velocity += movement
	velocity = move_and_slide(velocity, UP)
	
	if is_on_floor():
		velocity.x = lerp(velocity.x, 0, friction)
		if velocity.y > 0:
			velocity.y = gravity * delta
