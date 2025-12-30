extends Control

@onready var score_label: Label = $VBoxContainer/ScoreLabel
@onready var high_score_label: Label = $VBoxContainer/HighScoreLabel
@onready var new_high_label: Label = $VBoxContainer/NewHighScoreLabel
@onready var restart_button: Button = $VBoxContainer/RestartButton
@onready var main_menu_button: Button = $VBoxContainer/MainMenuButton
@onready var close_button: Button = $VBoxContainer/CloseButton

func _ready() -> void:
	# Display final score
	var final_score = Global.score
	var high_score = Global.high_score
	
	score_label.text = "Time Survived: %.1fs" % final_score
	high_score_label.text = "High Score: %.1fs" % high_score
	
	# Check for new high score
	if final_score >= high_score and final_score > 0:
		new_high_label.visible = true
		new_high_label.text = "🎉 New High Score!"
	else:
		new_high_label.visible = false
	
	# Connect buttons
	restart_button.pressed.connect(_on_restart_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	close_button.pressed.connect(_on_close_pressed)

func _on_restart_pressed() -> void:
	Global.reset_score()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_main_menu_pressed() -> void:
	Global.reset_score()
	get_tree().change_scene_to_file("res://scenes/StartScreen.tscn")

func _on_close_pressed() -> void:
	get_tree().quit()