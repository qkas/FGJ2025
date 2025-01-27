extends Node3D

@onready var boat: RigidBody3D = $Boat
@onready var fisher: Node3D = $Boat/Fisher

const TASK_ENTRY = preload("res://ui/task_entry.tscn")

var fishes: Array[String] = ['Swordfish', 'Lionfish', 'Squid', 'Blue shark']

var is_pike_roaming: bool = false

var game_started: bool = false

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("exit"):
		quit_game()

func _ready() -> void:
	for fish in fishes:
		var task_entry = TASK_ENTRY.instantiate()
		task_entry.set_label("Catch a %s." % fish)
		$CanvasLayer/TaskContainer.add_child(task_entry)
		
func _physics_process(delta: float) -> void:
	get_tree().call_group("chasing_pike", "update_target_location",boat.global_transform.origin)

func start_game() -> void:
	$ClickSFX.play()
	game_started = true
	boat.animate_camera()
	$CanvasLayer/MainMenu.hide()
	$CanvasLayer/TaskContainer.show()

func display_message(message: String) -> void:
	$CanvasLayer/Label.text = message
	$CanvasLayer/Label/MessageTimer.start()

func clear_message() -> void:
	$CanvasLayer/Label.text = ""

func quit_game() -> void:
	$ClickSFX.play()
	get_tree().quit()
