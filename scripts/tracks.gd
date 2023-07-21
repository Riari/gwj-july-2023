extends Node3D

func init(track_count: int, track_spacing: int, track_scene: PackedScene, spawn_interval_min: int, spawn_interval_max: int, train_speed: float):
	for n in track_count:
		var track = track_scene.instantiate()
		self.add_child(track)
		track.set_spawn_interval(spawn_interval_min, spawn_interval_max)
		track.set_train_direction(Globals.TrainDirection.NORTH if (n % 2) == 0 else Globals.TrainDirection.SOUTH)
		track.set_train_speed(train_speed)
		track.restart_spawn_timer()
		track.position.z += n * track_spacing
	
	self.position.z -= floor(float(track_count) / 2.0) * track_spacing
