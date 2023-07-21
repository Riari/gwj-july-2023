extends Node3D

# Track settings
@export var track_count: int = 5
@export var track_spacing: int = 8
@export var track_scene: PackedScene

# Train settings
@export_range (1, 20) var train_spawn_interval_min: int = 1 # per track in seconds
@export_range (1, 20) var train_spawn_interval_max: int = 20 # per track in seconds
@export var train_speed: float = 0.5

@onready var tracks = $Tracks

func _ready():
	tracks.build(track_count, track_spacing, track_scene, train_spawn_interval_min, train_spawn_interval_max, train_speed)
