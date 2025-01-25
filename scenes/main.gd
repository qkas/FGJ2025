extends Node3D

@onready var boat: RigidBody3D = $Boat
@onready var fisher: Node3D = $Boat/Fisher

var game_started: bool = false

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("exit"):
		quit_game()
	if Input.is_action_just_pressed("camera_switch"):
		$Boat.check_distance()

func start_game() -> void:
	game_started = true
	boat.animate_camera()
	$CanvasLayer/MainMenu.hide()

func quit_game() -> void:
	get_tree().quit()

func spawn_fishing_spots() -> void:
	pass

	
