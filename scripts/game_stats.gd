extends Node

var followers: float = 0
var government_awareness: float = 0
var selected_conspiracy: String = ""
var days_passed: int = 0
var can_continue: bool = false
signal game_over(is_win: bool, message: String)
signal show_tap_continue

func _init():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _ready():
	reset_stats()
	Wallet.money = 1000

func reset_stats():
	followers = 0
	government_awareness = 0
	selected_conspiracy = ""
	days_passed = 0
	can_continue = false

func check_game_over():
	if followers >= 100:
		can_continue = true
		emit_signal("game_over", true, "Awesome chief, we managed to make\npeople believe in our theory\nIn %d days!\nFinal Money: %d" % [days_passed, Wallet.get_money()])
		emit_signal("show_tap_continue")
		return true
	elif government_awareness >= 100:
		can_continue = true
		emit_signal("game_over", false, "Good try chief, but we failed to make\npeople believe in our theory\nThe government was ahead of us!\nDays lasted: %d\nFinal Money: %d" % [days_passed, Wallet.get_money()])
		emit_signal("show_tap_continue")
		return true
	return false

func handle_tap_input(event):
	if event is InputEventMouseButton and event.pressed and can_continue:
		get_tree().change_scene_to_file("res://scenes/loading_screen.tscn")

func increase_day():
	days_passed += 1
	check_game_over()

func increase_followers(amount: float, cost: int = 0):
	if cost > 0:
		if not Wallet.remove_money(cost):
			return false
	followers = min(followers + amount, 100)
	check_game_over()
	return true

func increase_government(amount: float):
	government_awareness = min(government_awareness + amount, 100)
	check_game_over()
