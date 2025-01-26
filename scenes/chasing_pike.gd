extends CharacterBody3D

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var boat = $"../../Boat"
var SPEED = 1.5
@onready var chasing_pikes: Node3D = $".."

var game_over : bool = false

func _process(delta: float) -> void:
	if not $/root/Main.game_started:
		return
	
	if position.distance_to(boat.position) < 7 and not game_over:
		boat.get_node("Pike/AnimationPlayer").play("attack")
		var timer = Timer.new()
		get_tree().root.add_child(timer)
		timer.start(0.7)
		timer.timeout.connect(hide_boat)
		var timer2 = Timer.new()
		get_tree().root.add_child(timer2)
		timer2.start(2.7)
		timer2.timeout.connect(end_game)

func hide_boat():
	$"../../Boat".hide()
	$"../..".display_message("You got eaten by the big pike!")

func end_game():
	get_tree().reload_current_scene()

func _physics_process(_delta: float) -> void:
	if not $/root/Main.game_started:
		return
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	velocity = new_velocity
	move_and_slide()

func update_target_location(target_location):
	nav_agent.target_position = target_location
