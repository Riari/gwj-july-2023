extends Node3D

@onready var spawn_timer: Timer = $SpawnTimer
@export var train_scene: PackedScene = preload("res://scenes/objects/train.tscn")

var has_spawned = false
var spawn_mode: int
var spawn_colour: Globals.Colour
var spawn_initial_interval_min: int
var spawn_interval_min: int
var spawn_interval_max: int
var train_direction: Globals.TrainDirection
var train_speed: float

var rng = RandomNumberGenerator.new()

signal train_received_crate(train, crate, total_received)

func set_spawn_mode(mode: int, track_index: int):
	spawn_mode = mode

	if mode == 0: # Fixed
		spawn_colour = Globals.EnabledColours[track_index]

func set_spawn_interval(initial_interval_min: int, interval_min: int, interval_max: int):
	spawn_initial_interval_min = initial_interval_min
	spawn_interval_min = interval_min
	spawn_interval_max = interval_max

func set_train_direction(direction: Globals.TrainDirection):
	train_direction = direction

func set_train_speed(speed: float):
	train_speed = speed

func pause_spawn_timer():
	spawn_timer.paused = true

func restart_spawn_timer():
	spawn_timer.paused = false
	var interval_min = spawn_interval_min if has_spawned else spawn_initial_interval_min
	spawn_timer.wait_time = float(rng.randf_range(interval_min, spawn_interval_max))
	spawn_timer.start()

func on_spawn_timer_timeout():
	restart_spawn_timer()
	spawn_train(Globals.get_random_colour() if spawn_mode == 1 else spawn_colour)

func on_train_received_crate(train: Node3D, crate: RigidBody3D, total_received: int):
	train_received_crate.emit(train, crate, total_received)

func spawn_train(colour: Globals.Colour):
	var train = train_scene.instantiate()
	train.init(colour, train_direction, train_speed)

	train.received_crate.connect(on_train_received_crate)

	self.add_child(train)

	has_spawned = true
