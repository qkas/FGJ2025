extends HBoxContainer

func set_label(text: String) -> void:
	$TextMargin/Label.text = text

func check_task() -> void:
	$TextMargin/ProgressBar/AnimationPlayer.play("check_done")
