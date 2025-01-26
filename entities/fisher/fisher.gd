extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var bobber: RigidBody3D = $Armature/Skeleton3D/BoneAttachment3D/FishingRod/Bobber
@onready var bobber_initial_position: Vector3 = bobber.position

@onready var fishables: Array[Node] = $Fishables.get_children()

var cast_strength : float = 5

var timer_range_min: float = 1
var timer_range_max: float = 3

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("fish") and $/root/Main.game_started:
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
	bobber.reparent(self)

func throw_hook() -> void:
	bobber.freeze = false
	bobber.is_flying = true
	bobber.reparent(get_tree().root)
	var global_direction = global_transform.basis * Vector3(0, 1.6, -1)
	bobber.apply_impulse(global_direction * cast_strength)

func start_timer() -> void: # called on bobber landed 
	$FishingTimer.start(randf_range(timer_range_min, timer_range_max))

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == 'fishing_reel':
		cancel_fishing()
		$/root/Main.get_random_item()
		print(animation_player.current_animation)

func start_reeling() -> void: # on timer timeout
	bobber.reparent($Armature/Skeleton3D/BoneAttachment3D/FishingRod)
	bobber.freeze = true
	bobber.is_flying = false
	animation_player.play('fishing_reel')
