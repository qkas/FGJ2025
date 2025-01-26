extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var bobber: RigidBody3D = $Armature/Skeleton3D/BoneAttachment3D/FishingRod/Bobber
@onready var bobber_initial_position: Vector3 = bobber.position

var cast_strength : float = 2.2

var timer_range_min: float = 3
var timer_range_max: float = 12

func _input(_event: InputEvent) -> void:
	# if not $/root/Main.is_game_active:
	#	return
	if Input.is_action_just_pressed("fish"):
		var curr_anim = animation_player.current_animation
		if curr_anim == 'fishing_idle':
			animation_player.play("fishing_cast")
			$CastingTimer.start() # after delay calls throw hook
		else: # not currently fishing
			animation_player.play("fishing_idle")

func cancel_fishing() -> void:
	animation_player.play('fishing_idle')
	bobber.is_flying = false
	bobber.freeze = true
	bobber.position = bobber_initial_position

func reel_hook() -> void:
	pass

func throw_hook() -> void:
	bobber.freeze = false
	bobber.is_flying = true
	var global_direction = global_transform.basis * Vector3(0, 2, -1)
	bobber.apply_impulse(global_direction * cast_strength)

func start_timer() -> void: # called on bobber landed 
	$FishingTimer.start(randf_range(timer_range_min, timer_range_max))

func get_random_fish() -> void:
	pass

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == 'fishing_cast':
		animation_player
	if anim_name == 'fishing_reel':
		cancel_fishing()
		$/root/Game.get_random_fish()

func start_reeling() -> void: # on timer timeout
	animation_player.play('fishing_reel')
