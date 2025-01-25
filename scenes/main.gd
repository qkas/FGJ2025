extends Node3D

@onready var boat: RigidBody3D = $Boat


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("exit"):
		quit_game()

func start_game() -> void:
	boat.animate_camera()
	$CanvasLayer/MainMenu.hide()

func quit_game() -> void:
	get_tree().quit()
