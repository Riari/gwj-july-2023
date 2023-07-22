extends Control

@onready var cursor_attachments = $CursorAttachments
@onready var discard_progress = $CursorAttachments/DiscardProgress
@onready var next_crate_preview_scene = $NextCratePreview/SubViewportContainer/SubViewport/Scene
@onready var next_crate_overlay = $NextCratePreview/Overlay
@onready var drop_cooldown_progress = $NextCratePreview/ProgressBar
@onready var points = $Score/Points

@export var camera: Camera3D

var is_discarding = false
var discard_time = 1.0
var discard_timer = 0.0

var is_drop_cooldown_active = false
var drop_cooldown_time = 1.0
var drop_cooldown_timer = 0.0

func _ready():
	cursor_attachments.visible = false
	points.text = "0"

func _process(delta):
	if is_discarding:
		discard_timer += delta
		discard_progress.value = remap(discard_timer, 0, discard_time, 0, discard_progress.max_value)

		if discard_timer >= discard_time:
			stop_discarding()

	if is_drop_cooldown_active:
		drop_cooldown_timer += delta
		drop_cooldown_progress.value = remap(drop_cooldown_timer, 0, drop_cooldown_time, 0, drop_cooldown_progress.max_value)

		if drop_cooldown_timer >= drop_cooldown_time:
			stop_cooldown()

	if not cursor_attachments.visible:
		return

	cursor_attachments.position = get_global_mouse_position()

func init(crate_discard_delay: float, crate_drop_cooldown: float):
	discard_time = crate_discard_delay
	drop_cooldown_time = crate_drop_cooldown

func on_crate_discard_started():
	cursor_attachments.visible = true
	is_discarding = true

func on_crate_discard_stopped():
	cursor_attachments.visible = false
	stop_discarding()

func on_crate_discard_cancelled():
	cursor_attachments.visible = false
	stop_discarding()

func stop_discarding():
	is_discarding = false
	discard_timer = 0.0
	discard_progress.value = 0

func stop_cooldown():
	is_drop_cooldown_active = false
	drop_cooldown_timer = 0.0
	drop_cooldown_progress.value = 0
	next_crate_overlay.visible = false

func on_crate_drop_cooldown_started():
	is_drop_cooldown_active = true
	next_crate_overlay.visible = true

func on_next_crate_colour_picked(colour: Globals.Colour):
	next_crate_preview_scene.set_colour(colour)

func on_total_score_updated(score: int):
	points.text = str(score)

func on_points_scored(points, world_position):
	pass # Replace with function body.
