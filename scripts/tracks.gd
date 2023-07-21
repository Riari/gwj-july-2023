extends Node

func build(track_count: int, track_spacing: int, track_scene: PackedScene):
	for n in track_count:
		var track = track_scene.instantiate()
		self.add_child(track)
		track.position.z += n * track_spacing
	
	self.position.z -= floor(float(track_count) / 2.0) * track_spacing
