extends RigidBody3D

signal on_bobber_landed

@export var buoyancy_power: float = 0

@onready var water_manager: WaterManager = $/root/Main/WaterManager

var is_flying: bool = false

# An incredibly simple showcase of the buoyancy
func _physics_process(delta: float) -> void:
	var _water_height = water_manager.calc_water_height(global_position)
	
	if global_position.y <= _water_height:
		if is_flying:
			is_flying = false
			on_bobber_landed.emit()
		global_position.y = _water_height + 0.1
		linear_velocity.x = 0
		linear_velocity.z = 0
