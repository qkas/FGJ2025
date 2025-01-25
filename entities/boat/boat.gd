extends RigidBody3D

@export var buoyancy_power : float = 1.0
@export var damper : float = 1.0
@export var archimedes_force : float = 1.0
@export var y_offset : float = -1.0
@export var points_array : Array[Node3D]
var water_manager : WaterManager
var last_water_y : float
@export var min_max_rotation : Vector3
var stored_rot
@export var fast_mode : bool = false
var initialized := false

@onready var camera_holder: Node3D = $CameraHolder
@onready var animation_player: AnimationPlayer = $CameraHolder/AnimationPlayer

@onready var foam_camera: Node3D = $"../FoamViewport/Base"

const ACCELERATION: float = 6.0
const MAX_SPEED: float = 10.0
const TURN_SPEED: float = 5.0
const MAX_TORQUE: float = 6.0
const WATER_DRAG: float = 0.99

var forward_input: float = 0.0
var turn_input: float = 0.0

var is_input_enabled: bool = false

func _ready():
	await get_tree().process_frame
	water_manager = %WaterManager
	if water_manager:
		initialized = true

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if not is_input_enabled:
		return
	
	var forward_dir = -transform.basis.z.normalized()
	forward_dir.y = 0
	forward_dir = forward_dir.normalized()
	
	# apply forward/backward movement
	forward_input = Input.get_action_strength("up") - Input.get_action_strength("down")
	if forward_input != 0:
		var force = forward_input * forward_dir * ACCELERATION
		state.apply_central_force(force * 10)
	
	# apply turning (local torque)
	turn_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	if turn_input != 0:
		var torque = -turn_input * TURN_SPEED
		# limit torque with MAX_TORQUE
		state.apply_torque_impulse(Vector3.UP * torque * 0.1)
	
	# apply water drag
	linear_velocity *= WATER_DRAG
	if linear_velocity.length() > MAX_SPEED:
		linear_velocity = linear_velocity.normalized() * MAX_SPEED

func _process(delta: float) -> void:
	camera_holder.global_rotation.z = 0

func _physics_process(_delta):
	if !initialized:
		return
	
	# fast mode is more performant so it will be used when the object is far away
	if fast_mode:
		var water_y = water_manager.fast_water_height(global_position)
		
		var k : float = (water_y - global_position.y)
		if k > 1.0:
			k = 1.0
		elif k< 0.0:
			k = 0.0
			
		var localDampingForce : float = -linear_velocity.y * damper * mass
		var force : float = localDampingForce + sqrt(k) * archimedes_force
		
		apply_central_force(Vector3(0, 1, 0) * force * buoyancy_power * points_array.size())
	else:
		for point in points_array:
			var point_pos : Vector3 = global_position + (global_position - point.global_position)
			point_pos.y += y_offset
			
			var water_y = water_manager.calc_water_height(point_pos)
			if point_pos.y < water_y:
				var k : float = (water_y - point_pos.y)
				
				k = clampf(k, 0, 1)
					
				var localDampingForce : float = -linear_velocity.y * damper * mass
				var force : float = localDampingForce + sqrt(k) * archimedes_force
				
				apply_force(Vector3(0, 1, 0) * force * buoyancy_power, (global_position - point.global_position))
	
	# clamp rotation
	var r_x = min(abs(rotation.x), min_max_rotation.x) * sign(rotation.x)
	var r_y = min(abs(rotation.y), min_max_rotation.y) * sign(rotation.y)
	var r_z = min(abs(rotation.z), min_max_rotation.z) * sign(rotation.z)
	rotation = Vector3(r_x, r_y, r_z)

func animate_camera() -> void:
	animation_player.play('initialize')
	camera_holder.top_level = false
	is_input_enabled = true
