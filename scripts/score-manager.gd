extends Node

var points = {} # Score table
var total_score = 0
var crates_on_ground = {}

var medals = {}

signal points_scored(points, world_position, combo)
signal total_score_updated(score)
signal medal_won(medal)

func init(points_correct_drop: int, points_combo_two: int, points_combo_three: int, points_discard: int, points_incorrect_drop: int, points_miss: int, target_score_bronze: int, target_score_silver: int, target_score_gold: int):
	points["correct_drop"] = points_correct_drop
	points["combo_two"] = points_combo_two
	points["combo_three"] = points_combo_three
	points["discard"] = points_discard
	points["incorrect_drop"] = points_incorrect_drop
	points["miss"] = points_miss
	medals["bronze"] = target_score_bronze
	medals["silver"] = target_score_silver
	medals["gold"] = target_score_gold

func award(points_to_award: int, position: Vector3, combo: int):
	total_score += points_to_award
	points_scored.emit(points_to_award, position, combo)
	total_score_updated.emit(total_score)

	if total_score >= medals["bronze"]:
		medal_won.emit(Globals.Medal.BRONZE)
	elif total_score >= medals["silver"]:
		medal_won.emit(Globals.Medal.SILVER)
	elif total_score >= medals["gold"]:
		medal_won.emit(Globals.Medal.GOLD)

func on_train_received_crate(train: Node3D, crate: RigidBody3D, total_received: int):
	var points_to_award = 0

	if train.get_meta("colour") == crate.get_meta("colour"):
		if total_received == 1:
			points_to_award = points["correct_drop"]
		elif total_received == 2:
			points_to_award = points["combo_two"]
		else:
			points_to_award = points["combo_three"]
	else:
		points_to_award = points["incorrect_drop"]

	if points_to_award != 0:
		award(points_to_award, crate.global_position, total_received)

func on_crate_discarded(crate: RigidBody3D):
	if points["discard"] != 0:
		award(points["discard"], crate.global_position, 0)

func on_ground_received_body(body: Node3D):
	var id = body.get_instance_id()
	if crates_on_ground.has(id) or not body.is_in_group("crate"):
		return

	crates_on_ground[id] = true

	if points["miss"] != 0:
		award(points["miss"], body.global_position, 0)
