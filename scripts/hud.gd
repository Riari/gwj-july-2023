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
@onready var node_icon_bronze = $LevelEndOverlay/Panel/Scores/IconBronze
@onready var node_label_bronze = $LevelEndOverlay/Panel/Scores/Bronze
@onready var node_icon_silver = $LevelEndOverlay/Panel/Scores/IconSilver
@onready var node_label_silver = $LevelEndOverlay/Panel/Scores/Silver
@onready var node_icon_gold = $LevelEndOverlay/Panel/Scores/IconGold
@onready var node_label_gold = $LevelEndOverlay/Panel/Scores/Gold
@onready var node_your_score_value = $LevelEndOverlay/Panel/Scores/YourScoreValue
@onready var node_stats = $LevelEndOverlay/Panel/Stats/Label
@onready var node_time_low_sound = $TimeLowSound

@export var camera: Camera3D

var is_discarding = false
var discard_time = 1.0
var discard_timer = 0.0

var is_drop_cooldown_active = false
var drop_cooldown_time = 1.0
var drop_cooldown_timer = 0.0

var target_scores = {}

var low_time_flash_duration = 0.5
var low_time_flash_timer = 0.0
var play_time_low_sound = false

var scene_score_popup = preload("res://scenes/ingame/ui/fragments/score-popup.tscn")

signal button_exit_pressed
signal button_try_again_pressed
signal button_continue_pressed

func _ready():
	node_cursor_attachments.visible = false
	node_level_end_overlay.visible = false
	node_points.text = "0"

func _process(delta):
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

	if play_time_low_sound:
		low_time_flash_timer -= delta

		if low_time_flash_timer <= 0:
			node_time_left.visible = !node_time_left.visible
			low_time_flash_timer = low_time_flash_duration

		if not node_time_low_sound.playing:
			node_time_low_sound.play()

	if not node_cursor_attachments.visible:
		return

	node_cursor_attachments.position = get_global_mouse_position()

func format_time(time_in_seconds: int):
	var seconds = time_in_seconds % 60
	var minutes = (time_in_seconds / 60) % 60

	return "%02d:%02d" % [minutes, seconds]

func init(time_limit: int, continue_enabled: bool, crate_discard_delay: float, crate_drop_cooldown: float, target_score_bronze: int, target_score_silver: int, target_score_gold: int):
	discard_time = crate_discard_delay
	drop_cooldown_time = crate_drop_cooldown

	if not continue_enabled:
		node_button_continue.visible = false
	else:
		node_button_continue.disabled = true

	node_countdown_overlay.visible = true

	node_time_left.text = format_time(ceil(time_limit))

	target_scores["bronze"] = target_score_bronze
	target_scores["silver"] = target_score_silver
	target_scores["gold"] = target_score_gold

	node_icon_bronze.modulate = Color(0, 0, 0, 1)
	node_label_bronze.text = str(target_score_bronze)
	node_icon_silver.modulate = Color(0, 0, 0, 1)
	node_label_silver.text = str(target_score_silver)
	node_icon_gold.modulate = Color(0, 0, 0, 1)
	node_label_gold.text = str(target_score_gold)

func on_countdown_timer_updated(time_left: float):
	node_countdown_time.text = "[b]" + str(ceil(time_left)) + "...[/b]"

func on_countdown_timer_ended():
	node_countdown_overlay.visible = false

func on_level_timer_updated(time_left: float):
	if time_left > 0 and time_left < 10:
		play_time_low_sound = true

	node_time_left.text = format_time(int(ceil(time_left)))

func on_level_timer_ended():
	node_level_end_overlay.visible = true
	play_time_low_sound = false
	node_time_left.visible = true
	node_time_low_sound.stop()

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
	node_your_score_value.text = str(score)

func on_points_scored(points: int, world_position: Vector3, combo: int):
	var screen_position = camera.unproject_position(world_position)
	var label = scene_score_popup.instantiate()
	label.position = screen_position
	label.set_value(points)
	node_score_popups.add_child(label)

	if points <= 0:
		return

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

func on_medal_won(medal: Globals.Medal):
	node_button_continue.disabled = false

	if medal == Globals.Medal.BRONZE:
		node_icon_bronze.modulate = Color(1, 1, 1, 1)
	
	if medal == Globals.Medal.SILVER:
		node_icon_silver.modulate = Color(1, 1, 1, 1)

	if medal == Globals.Medal.GOLD:
		node_icon_gold.modulate = Color(1, 1, 1, 1)

func on_stats_updated(stats: Dictionary):
	node_stats.text = "Stats\n\n" \
		+ "Ground drops:  " + str(stats["ground_drops"]) + "\n" \
		+ "Incorrect drops:  " + str(stats["incorrect_drops"]) + "\n" \
		+ "Correct drops:  " + str(stats["correct_drops"]) + "\n" \
		+ "Total combos:  " + str(stats["total_combos"]) + "\n" \
		+ "Discards:  " + str(stats["discards"]) + "\n" \
		+ "Total drops:  " + str(stats["total_drops"])
