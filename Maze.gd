extends Node2D

#export (int, "0", "90", "180", "270") var orientation = 0
#var desired_rotation_degrees = 0

export(int) var rotation_speed = 90

enum Orientation {
	DEG0 = 0
	DEG90 = 90
	DEG180 = 180
	DEG270 = 270
}
export(Orientation) var current_orientation
export(Orientation) var desired_orientation

func _input(event):
	if Input.is_action_just_pressed("ui_up"):
		match desired_orientation:
			Orientation.DEG0:
				desired_orientation = Orientation.DEG90
			Orientation.DEG90:
				desired_orientation = Orientation.DEG180
			Orientation.DEG180:
				desired_orientation = Orientation.DEG270
			Orientation.DEG270:
				desired_orientation = Orientation.DEG0
	if Input.is_action_just_pressed("ui_down"):
		match desired_orientation:
			Orientation.DEG0:
				desired_orientation = Orientation.DEG270
			Orientation.DEG90:
				desired_orientation = Orientation.DEG0
			Orientation.DEG180:
				desired_orientation = Orientation.DEG90
			Orientation.DEG270:
				desired_orientation = Orientation.DEG180

func _physics_process(delta):
	if current_orientation != desired_orientation:
		var dr = desired_orientation - rotation_degrees
		var rotation_direction = sign(dr)
		print(dr)
		if abs(dr) < 0.0001:
			rotation_degrees = desired_orientation
			current_orientation = desired_orientation
		else:
			rotation_degrees += rotation_direction * rotation_speed * delta
	
	# Keep the maze from spinning forever
	while rotation_degrees > 360:
		rotation_degrees -= 360
