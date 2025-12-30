extends Node2D

@onready var platform: Node2D = $Platform
@onready var ball: RigidBody2D = $Ball
@onready var score_label: Label = $UI/ScoreLabel
@onready var high_score_label: Label = $UI/HighScoreLabel

var game_active: bool = true
var platform_angle: float = 0.0
var max_tilt_angle: float = 0.5  # radians (~28 degrees)
var tilt_speed: float = 2.0
var auto_tilt_time: float = 0.0
var auto_tilt_direction: float = 1.0

func _ready() -> void:
	# Initialize UI
	_update_score_display()
	if high_score_label:
		high_score_label.text = "Best: %.1fs" % Global.high_score
		high_score_label.visible = true
	
	# Reset ball position
	ball.linear_velocity = Vector2.ZERO
	ball.angular_velocity = 0.0

func _process(delta: float) -> void:
	if not game_active:
		return
	
	# Update score
	Global.add_time(delta)
	_update_score_display()
	
	# Handle input
	var tilt_input: float = 0.0
	
	if Input.is_action_pressed("ui_left"):
		tilt_input = -1.0
	elif Input.is_action_pressed("ui_right"):
		tilt_input = 1.0
	
	# Apply tilt
	if tilt_input != 0.0:
		platform_angle += tilt_input * tilt_speed * delta
	else:
		# Auto-balance slowly
		platform_angle = move_toward(platform_angle, 0.0, tilt_speed * 0.3 * delta)
	
	# Clamp angle
	platform_angle = clamp(platform_angle, -max_tilt_angle, max_tilt_angle)
	
	# Apply rotation to platform
	platform.rotation = platform_angle
	
	# Check if ball fell off
	_check_ball_position()

func _update_score_display() -> void:
	if score_label:
		score_label.text = "Time: %.1fs" % Global.score

func _check_ball_position() -> void:
	# Check if ball is below the platform or off screen
	if ball.global_position.y > 700 or ball.global_position.x < -50 or ball.global_position.x > 850:
		_game_over()

func _game_over() -> void:
	game_active = false
	
	# Update high score if needed
	if Global.score > Global.high_score:
		Global.set_high_score(Global.score)
		_save_score()
	
	# Change to game over screen
	get_tree().change_scene_to_file("res://scenes/DefeatScreen.tscn")

func _save_score() -> void:
	if OS.has_feature("web"):
		var player_name = Global.last_player_name
		var score = Global.score
		JavaScriptBridge.eval("""
			window.parent.postMessage({
				type: 'applaa-game-save-score',
				gameId: 'ball-balance',
				playerName: '%s',
				score: %f
			}, '*');
		""" % [player_name, score])