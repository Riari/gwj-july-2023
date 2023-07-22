extends Node3D

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
# The minimum spawn interval per track in seconds, for all spawns after the first
@export_range (1, 20) var train_spawn_interval_min: int = 1
# The maximum spawn interval per track in seconds
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

@onready var hud = $HUD
@onready var tracks = $Tracks
@onready var crates = $Crates
@onready var score_manager = $ScoreManager

func _ready():
	hud.init(
		crate_discard_delay,
		crate_drop_cooldown
	)

	tracks.init(
		track_count,
		track_spacing,
		track_scene,
		train_spawn_mode,
		train_spawn_initial_interval_min,
		train_spawn_interval_min,
		train_spawn_interval_max,
		train_speed
	)

	crates.init(
		train_spawn_mode,
		track_count,
		crate_discard_delay,
		crate_drop_cooldown
	)

	score_manager.init(
		points_correct_drop,
		points_combo_two,
		points_combo_three,
		points_discard,
		points_incorrect_drop,
		points_miss
	)
