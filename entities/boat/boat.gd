extends CharacterBody3D

@onready var camera_holder: Node3D = $CameraHolder
@onready var animation_player: AnimationPlayer = $CameraHolder/AnimationPlayer

const MAX_ZOOM: float = 1
const MIN_ZOOM: float = -1

const SPEED = 5.0

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(0, 0, input_dir.y)).normalized()
	rotate_y(deg_to_rad(input_dir.x))
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED*0.01)
		velocity.z = move_toward(velocity.z, 0, SPEED*0.01)

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_pressed():
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP and camera_holder.position.y < MAX_ZOOM:
				camera_holder.position.y += 0.1
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and camera_holder.position.y > MIN_ZOOM:
				camera_holder.position.y -= 0.1

func camera_zoom_in():
	animation_player.play("initialize")
