extends HBoxContainer

func make_task(task: String) -> void:
	$TextMargin/Label.text = task

func check_task() -> void:
	$TextMargin/ProgressBar/AnimationPlayer.play("progress_bar")
