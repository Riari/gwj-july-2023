extends Node3D

@export var crate_scene: PackedScene

@export var camera: Camera3D

var current_crate: Node3D

const RAY_LENGTH = 1000.0

func _ready():
	spawn_crate()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			current_crate.freeze = false
			spawn_crate()

	if current_crate.freeze and event is InputEventMouseMotion:
		current_crate.position = calculate_crate_position(event.position)

func spawn_crate():
	current_crate = crate_scene.instantiate()
	var colour = Globals.get_random_colour()
	self.add_child(current_crate)
	current_crate.set_colour(colour)

func calculate_crate_position(mouse_position: Vector2):
	var space_state = get_world_3d().direct_space_state

	var from = camera.project_ray_origin(mouse_position)
	var to = from + camera.project_ray_normal(mouse_position) * RAY_LENGTH

	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.collide_with_areas = true
	query.exclude = [current_crate]

	var result = space_state.intersect_ray(query)

	return result.position
