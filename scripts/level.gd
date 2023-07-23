extends Node3D

## General settings
# Countdown before the game starts
@export var countdown: int = 3
# Time limit (in seconds) before the level ends (trains stop spawning and crates can't be dropped)
@export var time_limit: int = 45
# Whether it's possible to continue (i.e. there's another level)
@export var continue_enabled: bool = true

## Track settings
# How many tracks to spawn. Note: when using the "Fixed" spawn mode below, this MUST match the number of colours enabled in globals.gd!
@export var track_count: int = 5
# How far apart the tracks should be
@export var track_spacing: int = 8
# The scene to instantiate for each track
@export var track_scene: PackedScene

## Train settings
# The mode by which trains are spawned. "Fixed": a colour is assigned to each track. "Random": each track randomly picks a colour per spawn.
@export_enum ("Fixed", "Random") var train_spawn_mode: int = 0
# The minimum spawn interval per track in seconds, for the first spawn only
@export_range (1, 20) var train_spawn_initial_interval_min: int = 1
# The minimum spawn interval per track in seconds, for the first spawn only
@export_range (1, 20) var train_spawn_initial_interval_max: int = 3
# The minimum spawn interval per track in seconds, for all spawns after the first
@export_range (1, 20) var train_spawn_interval_min: int = 1
# The maximum spawn interval per track in seconds, for all spawns after the first
@export_range (1, 20) var train_spawn_interval_max: int = 20
# The speed of spawned trains
@export var train_speed: float = 7

## Crate settings
# How long it takes to confirm a discard
@export var crate_discard_delay: float = 1.0
# How frequently crates can be dropped
@export var crate_drop_cooldown: float = 0.5

## Score settings
# For correct drops into trains
@export var points_correct_drop: int = 10
# For two correct drops into the same train
@export var points_combo_two: int = 20
# For three or more correct drops into the same train
@export var points_combo_three: int = 50
# For discarded crates
@export var points_discard: int = 0
# For crates dropped into incorrect trains
@export var points_incorrect_drop: int = -3
# For crates dropped onto the ground
@export var points_miss: int = -5

@onready var node_hud = $HUD
@onready var node_tracks = $Tracks
@onready var node_crates = $Crates
@onready var node_score_manager = $ScoreManager
@onready var node_music = $Music
@onready var node_music_level_end = $MusicLevelEnd

signal request_exit
signal request_try_again
signal request_continue

func _ready():
	node_hud.init(
		countdown,
		time_limit,
		continue_enabled,
		crate_discard_delay,
		crate_drop_cooldown
	)

	node_tracks.init(
		track_count,
		track_spacing,
		track_scene,
		train_spawn_mode,
		train_spawn_initial_interval_min,
		train_spawn_initial_interval_max,
		train_spawn_interval_min,
		train_spawn_interval_max,
		train_speed
	)

	node_crates.init(
		train_spawn_mode,
		track_count,
		crate_discard_delay,
		crate_drop_cooldown
	)

	node_score_manager.init(
		points_correct_drop,
		points_combo_two,
		points_combo_three,
		points_discard,
		points_incorrect_drop,
		points_miss
	)

func on_time_out():
	node_music.stop()
	node_music_level_end.play()

func on_button_exit_pressed():
	request_exit.emit()

func on_button_try_again_pressed():
	request_try_again.emit()

func on_button_continue_pressed():
	request_continue.emit()
