extends Control

signal button_exit_pressed
signal button_try_again_pressed

func on_button_continue_pressed():
	self.visible = false
	get_tree().paused = false

func on_button_try_again_pressed():
	button_try_again_pressed.emit()

func on_button_exit_pressed():
	button_exit_pressed.emit()

func on_button_hamburger_pressed():
	self.visible = true
	get_tree().paused = true

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		self.visible = !self.visible
		get_tree().paused = self.visible
