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

func _ready():
	self.set_meta("is_crate", true)

func set_colour(colour: Globals.Colour):
	var material = load(Globals.MaterialsBasePath + colour_materials.get(colour))
	mesh.set_surface_override_material(0, material)
	self.set_meta("colour", colour)
