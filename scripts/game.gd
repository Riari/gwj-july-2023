extends Node

@onready var current_scene = $CurrentScene
@onready var button_sounds = $ButtonSounds

func load_scene(scene: PackedScene):
	current_scene.get_child(0).queue_free()
	var scene_instance = scene.instantiate()
	current_scene.add_child(scene_instance)
	button_sounds.connect_buttons()

func load_scene_file(path: String):
	var scene = load(path)
	load_scene(scene)
