class_name Globals

const MaterialsBasePath = "res://materials/"
enum Colour {BLACK, BLUE, BROWN, GREEN, ORANGE, RED, WHITE} # Train and crate colours
enum TrainDirection {NORTH, SOUTH}

const EnabledColours = [
	Globals.Colour.BLUE,
	Globals.Colour.GREEN,
	Globals.Colour.RED,
	Globals.Colour.BLACK,
	Globals.Colour.ORANGE,
	Globals.Colour.WHITE,
]

static var rng = RandomNumberGenerator.new()

static func get_random_colour():
	return EnabledColours[rng.randi_range(0, EnabledColours.size() - 1)]