extends Control

@onready var tap_continue = $TapToContinue
@onready var message_box = $MessageBox
@onready var tap_detector = $TapDetector

var followers: float = 0
var government_awareness: float = 0
var days_passed: int = 0
var can_continue: bool = false

func _ready():
	tap_continue.visible = false
	tap_continue.modulate.a = 0
	check_game_over()

func check_game_over():
	if followers >= 100:
		show_game_over(true)
	elif government_awareness >= 100:
		show_game_over(false)

func show_game_over(is_win: bool):
	var message = ""
	if is_win:
		message = "Awesome chief, we managed to make\npeople believe in our theory\nIn %d days!\nFinal Money: %d" % [days_passed, Wallet.get_money()]
	else:
		message = "Good try chief, but we failed to make\npeople believe in our theory\nThe government was ahead of us!\nDays lasted: %d\nFinal Money: %d" % [days_passed, Wallet.get_money()]
	
	message_box.text = message
	tap_continue.visible = true
	can_continue = true
	
	var tween = create_tween()
	tween.tween_property(tap_continue, "modulate:a", 1.0, 0.5)

func _on_tap_detector_input(event):
	if event is InputEventMouseButton and event.pressed and can_continue:
		get_tree().change_scene_to_file("res://scenes/loading_screen.tscn")
