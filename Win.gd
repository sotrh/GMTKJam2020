extends Control


func _process(_delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
