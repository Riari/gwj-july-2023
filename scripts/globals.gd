class_name Globals

const MaterialsBasePath = "res://materials/"
enum Colour {BLACK, BLUE, BROWN, GREEN, ORANGE, RED, WHITE} # Train and crate colours
enum TrainDirection {NORTH, SOUTH}

const EnabledColours = [
	Colour.BLUE,
	Colour.RED,
	Colour.ORANGE,
	Colour.GREEN,
	Colour.BLACK,
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

static func get_random_colour(range_max = EnabledColours.size() - 1):
	return EnabledColours[rng.randi_range(0, range_max)]