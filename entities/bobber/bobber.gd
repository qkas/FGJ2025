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

func _process(delta: float) -> void:
	if global_position.y <= 0: # stop the flying bobber on hitting sea level
		if abs(linear_velocity.x) > 1.0 or abs(linear_velocity.z) > 1.0:
			linear_velocity = Vector3.ZERO

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
