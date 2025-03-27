extends Control

@onready var date_label = $DateLabel
@onready var timer = $Timer

var total_elapsed_days = 0

signal day_changed(current_day)

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
	
	# Get current system date
	var current_date = Time.get_datetime_dict_from_system()
	
	# Lock the year to 1970
	game_date["year"] = 1990
	
	# Reset the starting day and month
	game_date["day"] = current_date["day"]
	game_date["month"] = current_date["month"]
	total_elapsed_days = 0


	# Validate nodes before using
	if date_label == null:
		push_error("❌ ERROR: DateLabel not found!")
		return

	if timer == null:
		push_error("❌ ERROR: Timer node not found!")
		return

	# Update the display
	update_date_label()
	
func _on_timer_timeout():
	# Increment both day counters
	game_date["day"] += 1
	total_elapsed_days += 1

	# Check for month rollover
	if game_date["day"] > days_per_month.get(game_date["month"], 31):
		game_date["day"] = 1
		game_date["month"] += 1

		# Handle year rollover (Now allows years to progress)
		if game_date["month"] > 12:
			game_date["month"] = 1
			game_date["year"] += 1  # Allow year to increment

	# Update UI first
	update_date_label()
	
	# Emit signal with total elapsed days
	emit_signal("day_changed", total_elapsed_days)

func update_date_label():
	if date_label:
		# Show both calendar date and total elapsed days
		date_label.text = "%02d %s %d (Day %d)" % [
			game_date["day"], 
			month_names.get(game_date["month"], "???"), 
			game_date["year"],
			total_elapsed_days
		]
	else:
		push_error("❌ ERROR: Cannot update DateLabel (node is missing).")
func set_game_speed(speed: float):
	game_speed = speed
	if timer:
		timer.wait_time = game_speed
		timer.start()
	else:
		push_error("❌ ERROR: Timer not found! Cannot change speed.")

func start_date_timer():
	if timer:
		timer.wait_time = game_speed
		if not timer.timeout.is_connected(_on_timer_timeout):
			timer.timeout.connect(_on_timer_timeout)
		timer.start()
	else:
		push_error("❌ ERROR: Timer not found! Cannot start date timer.")
