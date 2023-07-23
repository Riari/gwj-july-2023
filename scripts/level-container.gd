extends Node3D

@export var scene_next_level: PackedScene

func on_request_exit():
	get_tree().change_scene_to_file("res://scenes/main-menu.tscn")

func on_request_try_again():
	get_tree().reload_current_scene()

func on_request_continue():
	if scene_next_level == null:
		return
	
	get_tree().change_scene_to_packed(scene_next_level)
