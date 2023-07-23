extends Control

@export var node_label: Label
@export var color_positive: Color
@export var color_negative: Color

var speed = 5.0
var disappear_timer = 2.0

func set_value(value: int):
	print(node_label)
	node_label.text = str(value)
	if value < 0:
		node_label.add_theme_color_override("font_color", color_negative)
	else:
		node_label.add_theme_color_override("font_color", color_positive)

func _process(delta):
	disappear_timer -= delta
	self.position.y -= speed * delta

	if disappear_timer <= 0.0:
		queue_free()
