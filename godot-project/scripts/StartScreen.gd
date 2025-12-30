extends Control

@onready var high_score_label: Label = $VBoxContainer/HighScoreLabel
@onready var player_name_input: LineEdit = $VBoxContainer/PlayerNameInput
@onready var start_button: Button = $VBoxContainer/StartButton
@onready var close_button: Button = $VBoxContainer/CloseButton

func _ready() -> void:
	# Initialize high score display to 0
	if high_score_label:
		high_score_label.text = "High Score: 0.0s"
		high_score_label.visible = true
	
	# Connect buttons
	start_button.pressed.connect(_on_start_pressed)
	close_button.pressed.connect(_on_close_pressed)
	
	# Load saved data
	_load_game_data()

func _load_game_data() -> void:
	# Request data from Applaa storage
	if OS.has_feature("web"):
		JavaScriptBridge.eval("""
			window.parent.postMessage({
				type: 'applaa-game-load-data',
				gameId: 'ball-balance'
			}, '*');
		""")

func _update_display(high_score: float, last_player: String) -> void:
	if high_score_label:
		high_score_label.text = "High Score: %.1fs" % high_score
	
	if player_name_input and last_player != "":
		player_name_input.text = last_player
	
	Global.high_score = high_score
	Global.last_player_name = last_player

func _on_start_pressed() -> void:
	var player_name = player_name_input.text.strip_edges()
	if player_name == "":
		player_name = "Player"
	Global.last_player_name = player_name
	Global.reset_score()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_close_pressed() -> void:
	get_tree().quit()