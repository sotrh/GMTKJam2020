extends RigidBody2D



func _physics_process(delta):
	var movement = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
