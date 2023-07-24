extends Node3D

@export var scene_next_level: PackedScene

func on_request_exit():
	get_node("/root/Game").load_scene_file("res://scenes/main-menu.tscn")

func on_request_try_again():
	get_node("/root/Game").load_scene_file(self.scene_file_path)

func on_request_continue():
	if scene_next_level == null:
		return

	get_node("/root/Game").load_scene(scene_next_level)
