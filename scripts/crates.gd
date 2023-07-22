extends Node3D

@export var crate_scene: PackedScene

@export var camera: Camera3D

var current_crate: Node3D

var is_discarding = false
var discard_time: float
var discard_timer = 0.0

var is_drop_cooldown_active = false
var drop_cooldown_time: float
var drop_cooldown_timer = 0.0

var next_colour: Globals.Colour
var last_spawned_colour: Globals.Colour
var last_crate_was_discarded = false
var last_discarded_colour: Globals.Colour

signal drop_cooldown_started
signal discard_started
signal discard_cancelled
signal discard_finished(crate)
signal next_colour_picked(colour)
signal crate_collided_with(crate, body, collision_count)

const RAY_LENGTH = 1000.0

func _ready():
	queue_next_colour()
	spawn_next_crate()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			drop_crate()
		if event.button_index == MOUSE_BUTTON_RIGHT:
			is_discarding = event.pressed
			if event.pressed:
				discard_started.emit()
			else:
				discard_timer = 0.0
				discard_cancelled.emit()

func _process(delta):
	if is_discarding and discard_timer < discard_time:
		discard_timer += delta
	
	if discard_timer >= discard_time:
		discard_crate()

	if is_drop_cooldown_active:
		drop_cooldown_timer += delta

		if drop_cooldown_timer >= drop_cooldown_time:
			spawn_next_crate()
			drop_cooldown_timer = 0.0
			is_drop_cooldown_active = false

	if current_crate.freeze:
		current_crate.position = calculate_crate_position(get_viewport().get_mouse_position())

func init(crate_discard_delay: float, crate_drop_cooldown: float):
	discard_time = crate_discard_delay
	drop_cooldown_time = crate_drop_cooldown

func spawn_next_crate():
	last_crate_was_discarded = false
	current_crate = crate_scene.instantiate()
	current_crate.position.y = 100
	self.add_child(current_crate)
	current_crate.set_colour(next_colour)
	current_crate.collided_with.connect(on_crate_collided_with)
	last_spawned_colour = next_colour
	queue_next_colour()

func on_crate_collided_with(crate: RigidBody3D, body: Node3D, collision_count: int):
	crate_collided_with.emit(crate, body, collision_count)

func queue_next_colour():
	next_colour = Globals.get_random_colour()

	if last_crate_was_discarded and next_colour == last_discarded_colour:
		queue_next_colour()
		return
	
	next_colour_picked.emit(next_colour)

func drop_crate():
	current_crate.freeze = false
	is_drop_cooldown_active = true
	drop_cooldown_started.emit()

func discard_crate():
	last_discarded_colour = last_spawned_colour
	last_crate_was_discarded = true
	discard_timer = 0.0
	discard_finished.emit(current_crate)
	current_crate.queue_free()
	queue_next_colour()
	spawn_next_crate()

func calculate_crate_position(mouse_position: Vector2):
	var space_state = get_world_3d().direct_space_state

	var from = camera.project_ray_origin(mouse_position)
	var to = from + camera.project_ray_normal(mouse_position) * RAY_LENGTH

	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.collide_with_areas = true
	query.exclude = [current_crate]

	var result = space_state.intersect_ray(query)

	if result:
		return result.position
	
	return Vector3()
