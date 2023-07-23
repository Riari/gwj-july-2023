extends Control

@onready var node_cursor_attachments = $CursorAttachments
@onready var node_discard_progress = $CursorAttachments/DiscardProgress
@onready var node_next_crate_preview_scene = $NextCratePreview/SubViewportContainer/SubViewport/Scene
@onready var node_next_crate_overlay = $NextCratePreview/Overlay
@onready var node_drop_cooldown_progress = $NextCratePreview/ProgressBar
@onready var node_points = $Score/Points
@onready var node_time_left = $TimeLeft/Time
@onready var node_countdown_overlay = $CountdownOverlay
@onready var node_countdown_time = $CountdownOverlay/RichTextLabel
@onready var node_score_popups = $ScorePopups
@onready var node_sound_score_1 = $ScoreSounds/Score1
@onready var node_sound_score_2 = $ScoreSounds/Score2
@onready var node_sound_score_3 = $ScoreSounds/Score3
@onready var node_level_end_overlay = $LevelEndOverlay
@onready var node_button_continue = $LevelEndOverlay/Panel/ButtonContinue

@export var camera: Camera3D

var countdown: int
var time_left: float
var time_expired = false
var countdown_timer: float
var countdown_finished = false

var is_discarding = false
var discard_time = 1.0
var discard_timer = 0.0

var is_drop_cooldown_active = false
var drop_cooldown_time = 1.0
var drop_cooldown_timer = 0.0

var scene_score_popup = preload("res://scenes/ingame/ui/fragments/score-popup.tscn")

signal time_out
signal button_exit_pressed
signal button_try_again_pressed
signal button_continue_pressed

func _ready():
	node_cursor_attachments.visible = false
	node_level_end_overlay.visible = false
	node_points.text = "0"

func _process(delta):
	if not countdown_finished:
		countdown_timer -= delta

		if countdown_timer <= 0.0:
			countdown_finished = true
			node_countdown_overlay.visible = false

		update_countdown_timer()

		return
	
	# TODO: this should really be handled in the level script
	if time_left > 0:
		time_left -= delta
		node_time_left.text = format_time(ceil(time_left))
	elif not time_expired:
		time_expired = true
		time_out.emit()
		node_level_end_overlay.visible = true

	if is_discarding:
		discard_timer += delta
		node_discard_progress.value = remap(discard_timer, 0, discard_time, 0, node_discard_progress.max_value)

		if discard_timer >= discard_time:
			stop_discarding()

	if is_drop_cooldown_active:
		drop_cooldown_timer += delta
		node_drop_cooldown_progress.value = remap(drop_cooldown_timer, 0, drop_cooldown_time, 0, node_drop_cooldown_progress.max_value)

		if drop_cooldown_timer >= drop_cooldown_time:
			stop_cooldown()

	if not node_cursor_attachments.visible:
		return

	node_cursor_attachments.position = get_global_mouse_position()

func format_time(time_in_seconds: int):
	var seconds = time_in_seconds % 60
	var minutes = (time_in_seconds / 60) % 60

	return "%02d:%02d" % [minutes, seconds]

func init(countdown_: int, time_limit: int, continue_enabled: bool, crate_discard_delay: float, crate_drop_cooldown: float):
	countdown = countdown_
	countdown_timer = float(countdown)
	time_left = time_limit
	discard_time = crate_discard_delay
	drop_cooldown_time = crate_drop_cooldown

	if not continue_enabled:
		node_button_continue.visible = false

	node_countdown_overlay.visible = true
	update_countdown_timer()

	node_time_left.text = format_time(ceil(time_left))

func update_countdown_timer():
	node_countdown_time.text = "[b]" + str(ceil(countdown_timer)) + "...[/b]"

func on_crate_discard_started():
	node_cursor_attachments.visible = true
	is_discarding = true

func on_crate_discard_stopped():
	node_cursor_attachments.visible = false
	stop_discarding()

func on_crate_discard_cancelled():
	node_cursor_attachments.visible = false
	stop_discarding()

func stop_discarding():
	is_discarding = false
	discard_timer = 0.0
	node_discard_progress.value = 0

func stop_cooldown():
	is_drop_cooldown_active = false
	drop_cooldown_timer = 0.0
	node_drop_cooldown_progress.value = 0
	node_next_crate_overlay.visible = false

func on_crate_drop_cooldown_started():
	is_drop_cooldown_active = true
	node_next_crate_overlay.visible = true

func on_next_crate_colour_picked(colour: Globals.Colour):
	node_next_crate_preview_scene.set_colour(colour)

func on_total_score_updated(score: int):
	node_points.text = str(score)

func on_points_scored(points: int, world_position: Vector3, combo: int):
	var screen_position = camera.unproject_position(world_position)
	var label = scene_score_popup.instantiate()
	label.position = screen_position
	label.set_value(points)
	node_score_popups.add_child(label)

	if combo == 1:
		node_sound_score_1.play()
	elif combo == 2:
		node_sound_score_2.play()
	elif combo >= 3:
		node_sound_score_3.play()

func on_button_exit_pressed():
	button_exit_pressed.emit()

func on_button_try_again_pressed():
	button_try_again_pressed.emit()

func on_button_continue_pressed():
	button_continue_pressed.emit()
