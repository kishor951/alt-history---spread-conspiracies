extends Control

@onready var date_label = $DateLabel
@onready var timer = $Timer

# Game start date (locks the year to 1970, keeps real-world day/month)
var game_date = Time.get_datetime_dict_from_system()
var game_speed = 1.0  # Time speed (1.0 = normal, lower = slower, higher = faster)

# Days in each month (auto-updates for leap years)
var days_per_month = { 
	1: 31, 2: 28, 3: 31, 4: 30, 5: 31, 6: 30,
	7: 31, 8: 31, 9: 30, 10: 31, 11: 30, 12: 31
}

# Short month names for formatting
var month_names = { 
	1: "Jan", 2: "Feb", 3: "Mar", 4: "Apr", 5: "May", 6: "Jun",
	7: "Jul", 8: "Aug", 9: "Sep", 10: "Oct", 11: "Nov", 12: "Dec"
}

func _ready():
	# Lock the year to 1970
	game_date["year"] = 1970

	# Validate nodes before using
	if date_label == null:
		push_error("❌ ERROR: DateLabel not found!")
		return

	if timer == null:
		push_error("❌ ERROR: Timer node not found!")
		return

	# Update the display
	update_date_label()
	
	# Start the date timer
	timer.wait_time = game_speed
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _on_timer_timeout():
	# Increment the day
	game_date["day"] += 1

	# Check for leap years (1972, 1976, etc.)
	if game_date["year"] % 4 == 0:
		days_per_month[2] = 29  # February has 29 days in leap years
	else:
		days_per_month[2] = 28  # Normal years

	# Handle month/year rollover
	if game_date["day"] > days_per_month.get(game_date["month"], 31):
		game_date["day"] = 1
		game_date["month"] += 1

		# Handle year rollover (Always stays in 1970s)
		if game_date["month"] > 12:
			game_date["month"] = 1
			game_date["year"] = 1970  # Always stays in the 1970s

	# Update UI
	update_date_label()

func update_date_label():
	if date_label:
		date_label.text = "%02d %s %d" % [game_date["day"], month_names.get(game_date["month"], "???"), game_date["year"]]
	else:
		push_error("❌ ERROR: Cannot update DateLabel (node is missing).")

func set_game_speed(speed: float):
	game_speed = speed
	if timer:
		timer.wait_time = game_speed
		timer.start()
	else:
		push_error("❌ ERROR: Timer not found! Cannot change speed.")
