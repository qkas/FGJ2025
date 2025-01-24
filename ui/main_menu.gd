extends VBoxContainer

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("exit"):
		quit_game()

func quit_game() -> void:
	get_tree().quit()
