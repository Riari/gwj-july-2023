extends Node

@export_enum("Black", "Blue", "Brown", "Green", "Orange", "Red", "White") var colour: String
var material_base_path = "res://materials/"
var colour_materials = {
	"Black": "train-black.tres",
	"Blue": "train-blue.tres",
	"Brown": "train-brown.tres",
	"Green": "train-green.tres",
	"Orange": "train-orange.tres",
	"Red": "train-red.tres",
	"White": "train-white.tres"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	var locomotive = get_node("train-locomotive/Base_B_001")
	var gondola = get_node("train-car-gondola/GondolaCar")

	var material = load(material_base_path + colour_materials[colour])
	
	locomotive.set_surface_override_material(0, material)
	gondola.set_surface_override_material(0, material)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
