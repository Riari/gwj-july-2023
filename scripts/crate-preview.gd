extends Node3D

@onready var crate = $Crate

func set_colour(colour: Globals.Colour):
	crate.set_colour(colour)