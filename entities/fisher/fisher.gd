extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var bobber: RigidBody3D = $Bobber

var is_fishing: bool = false
var cast_strength : float = 5.00

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("fish"):
		var curr_anim = animation_player.current_animation
		if curr_anim == 'fishing_idle' and not is_fishing:
			animation_player.play("fishing_cast")
			bobber.freeze = false
			var global_direction = global_transform.basis * Vector3(0, 2, -1)
			bobber.apply_impulse(global_direction * cast_strength)

func start_minigame(difficulity: float) -> void:
	pass

func get_fish() -> void:
	pass

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	animation_player.play('fishign_idle')
	if anim_name == 'fishing_cast':
		is_fishing = true
		bobber.freeze = false
		bobber.apply_impulse(Vector3(0, 2, -1) * cast_strength)
	if anim_name == 'fishing_reel':
		get_fish()
