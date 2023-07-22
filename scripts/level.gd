extends Node3D

# Track settings
@export var track_count: int = 5
@export var track_spacing: int = 8
@export var track_scene: PackedScene

# Train settings
@export_range (1, 20) var train_spawn_interval_min: int = 1 # per track in seconds
@export_range (1, 20) var train_spawn_interval_max: int = 20 # per track in seconds
@export var train_speed: float = 7

# Crate settings
@export var crate_discard_delay: float = 1.0
@export var crate_drop_cooldown: float = 0.5

# Score settings
@export var points_correct_drop: int = 10
@export var points_combo_two: int = 20
@export var points_combo_three: int = 50
@export var points_discard: int = 0
@export var points_incorrect_drop: int = -3
@export var points_miss: int = -5

@onready var hud = $HUD
@onready var tracks = $Tracks
@onready var crates = $Crates
@onready var score_manager = $ScoreManager

func _ready():
	hud.init(crate_discard_delay, crate_drop_cooldown)
	tracks.init(track_count, track_spacing, track_scene, train_spawn_interval_min, train_spawn_interval_max, train_speed)
	crates.init(crate_discard_delay, crate_drop_cooldown)
	score_manager.init(points_correct_drop, points_combo_two, points_combo_three, points_discard, points_incorrect_drop, points_miss)
