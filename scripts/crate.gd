extends RigidBody3D

var colour_materials = {
	Globals.Colour.BLACK: "crate-black.tres",
	Globals.Colour.BLUE: "crate-blue.tres",
	Globals.Colour.BROWN: "crate-brown.tres",
	Globals.Colour.GREEN: "crate-green.tres",
	Globals.Colour.ORANGE: "crate-orange.tres",
	Globals.Colour.RED: "crate-red.tres",
	Globals.Colour.WHITE: "crate-white.tres"
}

@onready var mesh: MeshInstance3D = $Mesh

var collision_count = 0

signal collided_with(this, other, collision_count)

func set_colour(colour: Globals.Colour):
	var material = load(Globals.MaterialsBasePath + colour_materials.get(colour))
	mesh.set_surface_override_material(0, material)
	self.set_meta("colour", colour)

func on_body_entered(body: Node):
	collision_count += 1
	collided_with.emit(self, body, collision_count)
