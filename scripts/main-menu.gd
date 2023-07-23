extends Node3D

@onready var north_train = $NorthTrain
@onready var south_train = $SouthTrain

func _ready():
	north_train.init(Globals.Colour.BLACK, Globals.TrainDirection.NORTH, 11.0)
	south_train.init(Globals.Colour.WHITE, Globals.TrainDirection.SOUTH, 8.0)