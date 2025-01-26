extends Node3D

@onready var boat: RigidBody3D = $Boat
@onready var fisher: Node3D = $Boat/Fisher

const TASK_ENTRY = preload("res://ui/task_entry.tscn")

var fishes: Array[String] = ['Lionfish', 'Blue shark', 'Swordfish', 'Squid']

var fish_count: int = len(fishes)

var is_pike_roaming: bool = false

var game_started: bool = false
var game_over : bool = false

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
	game_started = true
	boat.animate_camera()
	$CanvasLayer/MainMenu.hide()
	$CanvasLayer/TaskContainer.show()

func mark_task_done(index: int) -> void:
	$CanvasLayer/TaskContainer.get_child(index).check_task()
	fish_count -= 1
	if fish_count == 0:
		display_message("You won the game, congratulations!")
		var timer = Timer.new()
		get_tree().root.add_child(timer)
		timer.start(1)
		timer.timeout.connect(end_game)

func end_game():
	get_tree().reload_current_scene()

func display_message(message: String) -> void:
	$CanvasLayer/Label.text = message
	$CanvasLayer/Label/MessageTimer.start()

func clear_message() -> void:
	$CanvasLayer/Label.text = ""

func quit_game() -> void:
	get_tree().quit()
