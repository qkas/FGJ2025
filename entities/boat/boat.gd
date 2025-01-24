extends Node3D
@onready var camera_pivot: Node3D = $CameraPivot

var yMax = 1
var yMin = -1


func _input(event: InputEvent) -> void:
	if event.is_pressed():
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP && camera_pivot.position.y < yMax:
				camera_pivot.position.y += 0.1
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN  && camera_pivot.position.y > yMin:
				camera_pivot.position.y -= 0.1
