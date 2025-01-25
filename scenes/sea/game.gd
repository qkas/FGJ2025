extends Node3D

@onready var fisher: Node3D = $Boat/Fisher
@onready var boat: CharacterBody3D = $Boat

func start_game():
	boat.camera_zoom_in()
	$CanvasLayer/MainMenu.hide()
