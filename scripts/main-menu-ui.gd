extends Control

@onready var panel_play = $PanelPlay
@onready var panel_credits = $PanelCredits

var level_1 = preload("res://scenes/ingame/levels/1.tscn")

func on_button_play_pressed():
	panel_play.visible = true

func on_button_play_play_pressed():
	get_node("/root/Game").load_scene(level_1)

func on_button_play_back_pressed():
	panel_play.visible = false

func on_button_credits_pressed():
	panel_credits.visible = true

func on_button_credits_back_pressed():
	panel_credits.visible = false

func on_button_exit_pressed():
	get_tree().quit()
