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


func _physics_process(delta):
	if current_orientation != desired_orientation:
		var dr = desired_orientation - rotation_degrees
		var rotation_direction = sign(dr)
		print(dr)
		if abs(dr) < 0.000001:
			rotation_degrees = desired_orientation
			current_orientation = desired_orientation
		else:
			rotation_degrees += rotation_direction * rotation_speed * delta
	
	# Keep the maze from spinning forever
	while rotation_degrees > 360:
		rotation_degrees -= 360
