extends Node

@onready var effect_crate_hit_train_1 = preload("res://audio/effect_crate_hit_train_1.mp3")
@onready var effect_crate_hit_train_2 = preload("res://audio/effect_crate_hit_train_2.mp3")
@onready var effect_crate_hit_ground_1 = preload("res://audio/effect_crate_hit_ground_1.mp3")
@onready var effect_crate_hit_crate_1 = preload("res://audio/effect_crate_hit_crate_1.mp3")

@onready var effects_crate_hit_train = [
	preload("res://audio/effect_crate_hit_train_1.mp3"),
	preload("res://audio/effect_crate_hit_train_2.mp3"),
	preload("res://audio/effect_crate_hit_train_3.mp3")
]

# Minimum velocity required on any axis to trigger a sound
var crate_velocity_factor = 2.5

var rng = RandomNumberGenerator.new()

var last_played_slot = 0

# Plays the specified sound effect using one of the AudioStream3D child nodes.
# (Doesn't do any filtering, so don't put nodes of a type other than AudioStream3D inside this one!)
func play_effect(at: Vector3, effect: AudioStream):
	last_played_slot += 1

	if last_played_slot == get_child_count():
		last_played_slot = 0

	var slot = get_child(last_played_slot)
	slot.position = at
	slot.stream = effect
	slot.play()

func should_play_effect(crate: RigidBody3D):
	return (abs(crate.linear_velocity.x) >= crate_velocity_factor
		or abs(crate.linear_velocity.y) >= crate_velocity_factor
		or abs(crate.linear_velocity.z) >= crate_velocity_factor)

func on_train_received_crate(_train: Node3D, crate: RigidBody3D, _total_received: int):
	if (should_play_effect(crate)):
		play_effect(crate.global_position, effects_crate_hit_train[rng.randi_range(0, effects_crate_hit_train.size() - 1)])

func on_crate_collided_with_body(crate: RigidBody3D, body: Node3D, collision_count: int):
	if not body.is_in_group("ground") and not should_play_effect(crate):
		return

	if body.is_in_group("crate"):
		play_effect(crate.global_position, effect_crate_hit_crate_1)
	
	if body.is_in_group("train"):
		play_effect(crate.global_position, effect_crate_hit_train_2)

	if body.is_in_group("ground"):
		# Ugly workaround for linear velocity being almost zero when the crate hits the ground for the first time
		if collision_count == 1 or should_play_effect(crate):
			play_effect(crate.global_position, effect_crate_hit_ground_1)
