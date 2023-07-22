extends Node3D

var colour_materials = {
	Globals.Colour.BLACK: "train-black.tres",
	Globals.Colour.BLUE: "train-blue.tres",
	Globals.Colour.BROWN: "train-brown.tres",
	Globals.Colour.GREEN: "train-green.tres",
	Globals.Colour.ORANGE: "train-orange.tres",
	Globals.Colour.RED: "train-red.tres",
	Globals.Colour.WHITE: "train-white.tres"
}

# TODO: calculate these automatically based on camera settings
const START_X_NORTHBOUND = 36
const START_X_SOUTHBOUND = -28
const END_X_NORTHBOUND = -44
const END_X_SOUTHBOUND = 53
const ROTATION_Y_NORTHBOUND = 0.0
const ROTATION_Y_SOUTHBOUND = -180.0

var current_colour: Globals.Colour
var current_direction: Globals.TrainDirection
var current_speed: float

var crates_received = {}

signal received_crate(train, crate, total_crates)

@onready var gondola = $Gondola

func init(colour: Globals.Colour, direction: Globals.TrainDirection, speed: float):
	var locomotive_mesh = get_node("Locomotive/Base_B_001")
	var gondola_mesh = get_node("Gondola/GondolaCar")

	var material = load(Globals.MaterialsBasePath + colour_materials.get(colour))
	
	locomotive_mesh.set_surface_override_material(0, material)
	gondola_mesh.set_surface_override_material(0, material)

	match direction:
		Globals.TrainDirection.NORTH:
			self.position.x = START_X_NORTHBOUND
			self.rotation_degrees.y = ROTATION_Y_NORTHBOUND
		Globals.TrainDirection.SOUTH:
			self.position.x = START_X_SOUTHBOUND
			self.rotation_degrees.y = ROTATION_Y_SOUTHBOUND

	current_colour = colour
	current_direction = direction
	current_speed = speed

	self.set_meta("colour", colour)

func _process(delta):
	var move = current_speed * delta
	if current_direction == Globals.TrainDirection.NORTH:
		move = -move
		if self.position.x <= END_X_NORTHBOUND:
			despawn()
	elif self.position.x >= END_X_SOUTHBOUND:
		despawn()

	self.position.x += move

func despawn():
	queue_free()

# Triggers when an object enters the gondola car
func on_body_entered(body: Node3D):
	var id = body.get_instance_id()
	if crates_received.has(id) or not body.is_in_group("crate"):
		return

	crates_received[id] = true
	body.reparent(gondola)
	body.freeze = true

	received_crate.emit(self, body, crates_received.size())
