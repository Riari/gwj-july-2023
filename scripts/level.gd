extends Node

# Track settings
@export var track_count: int = 5
@export var track_spacing: int = 8
@export var track_scene: PackedScene

# Train settings
@export_range (3, 8) var train_spawn_interval: int # per track
@export var train_speed: float = 2.0

@onready var tracks = $Tracks
@onready var trains = $Trains

func _ready():
	$Tracks.build(track_count, track_spacing, track_scene)
