extends RigidBody3D

@export var buoyancy_power: float = 0

@onready var water_manager: WaterManager = $/root/Main/WaterManager

# An incredibly simple showcase of the buoyancy
func _physics_process(delta: float) -> void:
	var _water_height = water_manager.calc_water_height(global_position)
	
	if global_position.y > _water_height:
		gravity_scale = 1
	else:
		global_position.y = _water_height + 0.1
		linear_velocity.x = 0
		linear_velocity.z = 0
