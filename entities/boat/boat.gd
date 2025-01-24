extends CharacterBody3D

@onready var camera_holder: Node3D = $CameraHolder

var max_zoom: float = 1
var min_zoom: float = -1

const SPEED = 5.0

func _input(event: InputEvent) -> void:
	if event.is_pressed():
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP && camera_holder.position.y < max_zoom:
				camera_holder.position.y += 0.1
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN  && camera_holder.position.y > min_zoom:
				camera_holder.position.y -= 0.1

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
