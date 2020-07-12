extends Area2D

export(String, FILE, "*.tscn") var next_world

func _on_Goal_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene(next_world)
