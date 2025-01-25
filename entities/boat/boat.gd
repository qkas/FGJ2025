extends CharacterBody3D

@onready var camera_holder: Node3D = $CameraHolder

const max_zoom: float = 1
const min_zoom: float = -1
const drag_force: float = 5
const SPEED = 5.0
var zoomed_in : bool = false;


func _input(event: InputEvent) -> void:
	if event.is_pressed():
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP && camera_holder.position.y < max_zoom:
				camera_holder.position.y += 0.1
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN  && camera_holder.position.y > min_zoom:
				camera_holder.position.y -= 0.1
				
	if Input.is_key_pressed(KEY_C):
		#plays this in reverse
		if zoomed_in:
			$CameraHolder/AnimationPlayer.play("zoom_in",-1,-1, true)
			zoomed_in = false
		else:
			$CameraHolder/AnimationPlayer.play("zoom_in")
			zoomed_in = true
				
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
