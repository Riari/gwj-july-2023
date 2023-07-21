class_name Globals

const MaterialsBasePath = "res://materials/"
enum Colour {BLACK, BLUE, BROWN, GREEN, ORANGE, RED, WHITE} # Train and crate colours
enum TrainDirection {NORTH, SOUTH}

const EnabledColours = [
	Colour.BLUE,
	Colour.GREEN,
	Colour.RED,
	Colour.BLACK,
	Colour.ORANGE,
	Colour.WHITE,
]

const ColourLabels = {
	Colour.BLACK: "Black",
	Colour.BLUE: "Blue",
	Colour.BROWN: "Brown",
	Colour.GREEN: "Green",
	Colour.ORANGE: "Orange",
	Colour.RED: "Red",
	Colour.WHITE: "White"
}

static var rng = RandomNumberGenerator.new()

static func get_random_colour():
	return EnabledColours[rng.randi_range(0, EnabledColours.size() - 1)]