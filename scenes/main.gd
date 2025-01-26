extends Node3D

@onready var boat: RigidBody3D = $Boat
@onready var fisher: Node3D = $Boat/Fisher

const TASK_ENTRY = preload("res://ui/task_entry.tscn")

const fishes: Array[String] = ['Swordfish', 'Lionfish', 'Octopus', 'Blue shark']

var game_started: bool = false

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("exit"):
		quit_game()
	if Input.is_action_just_pressed("camera_switch"):
		$Boat.check_distance()

func _ready() -> void:
	for fish in fishes:
		var task_entry = TASK_ENTRY.instantiate()
		task_entry.set_label("Catch a %s." % fish)
		$CanvasLayer/TaskContainer.add_child(task_entry)

func start_game() -> void:
	game_started = true
	boat.animate_camera()
	$CanvasLayer/MainMenu.hide()
	$CanvasLayer/TaskContainer.show()

func get_random_fish() -> void:
	print("fish got got")

func quit_game() -> void:
	get_tree().quit()

func spawn_fishing_spots() -> void:
	pass

	
