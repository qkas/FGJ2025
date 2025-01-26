extends CharacterBody3D

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var boat = $"../../Boat"
var SPEED = 1.5
@onready var chasing_pikes: Node3D = $".."

var game_over : bool = false

func _process(delta: float) -> void:
	if position.distance_to(boat.position) < 7 and not game_over:
		boat.get_node("Pike/AnimationPlayer").play("attack")
		game_over = true

func _physics_process(delta: float) -> void:
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	velocity = new_velocity
	move_and_slide()

func update_target_location(target_location):
	nav_agent.target_position = target_location
