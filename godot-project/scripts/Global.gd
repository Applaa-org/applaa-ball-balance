extends Node

var score: float = 0.0
var high_score: float = 0.0
var last_player_name: String = ""

func add_time(delta: float) -> void:
	score += delta

func get_score() -> float:
	return score

func reset_score() -> void:
	score = 0.0

func set_high_score(value: float) -> void:
	if value > high_score:
		high_score = value

func get_high_score() -> float:
	return high_score