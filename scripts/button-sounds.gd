extends Node

@onready var button_sound = $AudioStreamPlayer

func _ready():
	connect_buttons()

func connect_buttons():
	var buttons = get_tree().get_nodes_in_group("button")
	for button in buttons:
		button.connect("pressed", on_button_pressed)

func on_button_pressed():
	button_sound.play()