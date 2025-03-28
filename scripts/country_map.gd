extends Node2D

signal day_changed(day)

# Update the node references at the top
@onready var stats_container = $"CanvasLayer/StatsContainer"
@onready var believability_bar = $"CanvasLayer/StatsContainer/Believability/ProgressBar"
@onready var exposure_bar = $"CanvasLayer/StatsContainer/Exposure/ProgressBar"
@onready var influence_bar = $"CanvasLayer/StatsContainer/Influence/ProgressBar"

@onready var believability_value = $"CanvasLayer/StatsContainer/Believability/Value"
@onready var exposure_value = $"CanvasLayer/StatsContainer/Exposure/Value"
@onready var influence_value = $"CanvasLayer/StatsContainer/Influence/Value"

# Keep existing country info panel references
@onready var country_info_panel = $"CanvasLayer/CountryInfoPanel"
@onready var country_name_label = $"CanvasLayer/CountryInfoPanel/CountryName"
@onready var population_label = $"CanvasLayer/CountryInfoPanel/Population"
@onready var followers_label = $"CanvasLayer/CountryInfoPanel/Followers"
@onready var summary_label = $"CanvasLayer/CountryInfoPanel/Summary"

@onready var countries_container = $CountriesContainer

@onready var animation_player = $CountriesContainer/AnimationPlayer

@onready var background_music = $BackgroundMusic

# For date calling from the DateDisplay.gd
@onready var date_display = $Calender/DateDisplay

var selected_country = null  # Track the selected country
var activation_done = false  # Prevents multiple activations

@onready var activation_button = $ActivationButton  # The activation button
@onready var activation_marker = $ActivationMarker  # The activation sprite

@onready var total_followers_bar = $FollowersBar

@onready var media_container = get_node("MediaContainer")

var info_panel_timer: Timer

var button_offset := Vector2(0, -10)

@onready var activation_sound = $ActivationSound
@onready var country_click_sound = $CountryClickSound

var global_followers = 0.0
var global_population = 0
var conversion_rate_base = 0.05  # 0.01% base conversion per day
var media_multipliers = {
	"Print": 1.0,
	"Satellite": 1.2,
	"Social": 1.3
}

# Add at the top with other @onready vars
@onready var result_panel = $CanvasLayer/ResultPanel
@onready var result_text = $CanvasLayer/ResultPanel/ResultText
@onready var replay_button = $CanvasLayer/ResultPanel/ReplayButton

@onready var government_bar = $"GovernmentBar"
var government_start_days = 0 #
var government_progress = 0.0
var base_government_speed = 0.25  # Base progress per day (0.05%)

@onready var upgrades_panel = $CanvasLayer/UpgradesPanel/UpgradesPanel  # Update the path to point to the actual Panel node
@onready var upgrade_button = $UpgradeButton

#At the top with other variables
@onready var countries_data = preload("res://scripts/countries_data.gd").new()

#Replace direct dictionary access with method calls
@onready var background = $EarthBackground  # Add this with your other @onready vars

func _ready():
	var panel = get_tree().get_root().find_child("CountryInfoPanel", true, false)

	date_display.connect("day_changed", Callable(self, "_on_day_changed"))

	activation_button.connect("pressed", Callable(self, "_on_ActivationButton_pressed"))

	activation_marker.visible = false
	
	initialize_media_states()
	initialize_media_visibility()
	
	# In _ready function
	for country_name in countries_data.get_all_country_names():
		var media_info = countries_data.get_media_info(country_name, "Print")
		if media_info.get("Visibility") == "Early":
			activate_media(media_info["MediaNumber"], "Print")
			set_media_state(country_name, "Print", true, false)
			countries_data.set_media_installed(country_name, "Print", true)
			
	# Configure fonts for UI elements
	var manrope_font = preload("res://assets/fonts/Manrope-VariableFont_wght.ttf")
	
	# Apply fonts and sizes to labels
	country_name_label.add_theme_font_override("font", manrope_font)
	country_name_label.add_theme_font_size_override("font_size", 20)
	
	population_label.add_theme_font_override("font", manrope_font)
	population_label.add_theme_font_size_override("font_size", 20)
	
	followers_label.add_theme_font_override("font", manrope_font)
	followers_label.add_theme_font_size_override("font_size", 20)
	
	summary_label.add_theme_font_override("font", manrope_font)
	summary_label.add_theme_font_size_override("font_size", 16)


	country_info_panel.visible = false
	stats_container.visible = true
	
	# Create timer for auto-hiding
	info_panel_timer = Timer.new()
	info_panel_timer.one_shot = true
	info_panel_timer.wait_time = 7.0  # 7 seconds before hiding
	info_panel_timer.timeout.connect(show_stats_panel)
	add_child(info_panel_timer)
	
	# Set progress bar ranges to 0-30
	influence_bar.min_value = 0
	influence_bar.max_value = 30
	believability_bar.min_value = 0
	believability_bar.max_value = 30
	exposure_bar.min_value = 0
	exposure_bar.max_value = 30
	
	# Initialize government progression
	government_bar.min_value = 0
	government_bar.max_value = 100
	government_bar.value = 0
	initialize_government_timing()
	
	# Remove duplicate connections and keep only one
	upgrade_button.pressed.connect(_on_upgrade_button_pressed)
	# Connect to the panel itself, not its parent
	upgrades_panel.upgrade_purchased.connect(_on_upgrade_purchased)
	upgrades_panel.visible = false

	upgrades_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	upgrades_panel.gui_input.connect(_on_upgrades_panel_gui_input)
	upgrades_panel.visible = false

	result_panel.visible = false

	if replay_button:
		replay_button.pressed.connect(_on_replay_button_pressed)

func _on_upgrades_panel_gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		get_viewport().set_input_as_handled()

	
func show_stats_panel():
	country_info_panel.visible = false
	stats_container.visible = true

func show_country_panel():
	country_info_panel.visible = true
	stats_container.visible = false
	# Reset timer
	info_panel_timer.start()
	
# In _on_day_changed function
# Modify _on_day_changed function to trigger spreading when new media becomes visible
func _on_day_changed(total_days):
	# Process any pending connections
	var connections_to_retry = pending_connections.duplicate()
	pending_connections.clear()
	
	for connection in connections_to_retry:
		connect_media_to_media(connection["source"], connection["target"], connection["type"])
	for country_name in countries_data.get_all_country_names():
		for media_type in ["Satellite", "Social"]:
			var media_info = countries_data.get_media_info(country_name, media_type)
			var media_state = get_media_state(country_name, media_type)
			
			if not media_info.is_empty() and not media_state["installed"]:
				var days_needed = get_media_visibility_days(media_info["Visibility"], media_type)
				
				if total_days >= days_needed:
					activate_media(media_info["MediaNumber"], media_type)
					set_media_state(country_name, media_type, true, false)
					print("✅ Activated " + media_type + " for " + country_name)
					
					# If this is the activation marked country, connect to hub and start spreading
					if country_name == selected_country:
						connect_media_to_hub(country_name, media_type)
						attempt_media_spread(country_name)
	update_followers_conversion()
	update_global_stats()
	update_government_progress(total_days)
	update_global_stats()

# Modify attempt_media_spread function to check visibility
# Complete the attempt_media_spread function
func attempt_media_spread(source_country: String):
	var source_number = int(countries_data.get_country_data(source_country)["CountryNumber"])
	#print("🔄 Attempting to spread from country #" + str(source_number) + " (" + source_country + ")")
	
	for media_type in ["Print", "Satellite", "Social"]:
		# Find source media node and check if it's visible
		var source_media = find_media_node(get_media_number(source_country, media_type), media_type)
		if not source_media or not source_media.visible:
			#print("⏭️ Skipping " + media_type + " - not visible in source country")
			continue
			
		var media_state = get_media_state(source_country, media_type)
		if not media_state["connected"]:
			#print("⏭️ Skipping " + media_type + " - not connected in source country")
			continue
		
		var target_country_number = calculate_spread_target(source_number, media_type)
		if target_country_number > 0:
			var target_country = find_country_by_number(target_country_number)
			if target_country and not is_media_connected(target_country, media_type):
				print("✨ Creating new " + media_type + " connection: " + source_country + " -> " + target_country)
				connect_media_to_media(source_country, target_country, media_type)
				
				# Schedule next spread from both countries
				schedule_next_spread(source_country)
				schedule_next_spread(target_country)

# Add new function to handle spread scheduling
func schedule_next_spread(country_name: String):
	var timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	# Base time reduced by exposure (0-30 range)
	var exposure_factor = 1.0 - (exposure_bar.value / 30.0) * 0.7  # Up to 70% reduction
	var base_time = 15.0 * exposure_factor  # Base time affected by exposure
	
	timer.wait_time = base_time * randf_range(1.0, 2.0)
	timer.timeout.connect(func(): attempt_media_spread(country_name))
	timer.start()

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		check_country_click(event.position)

func check_country_click(mouse_pos):

	for country in countries_container.get_children():
		if country is Sprite2D:

			var local_pos = country.to_local(mouse_pos)

			var sprite_rect = Rect2(
				-country.texture.get_width() / 2, 
				-country.texture.get_height() / 2, 
				country.texture.get_width(), 
				country.texture.get_height()
			)

			if sprite_rect.has_point(local_pos):
				# Play country click sound
				if country_click_sound:
					country_click_sound.play()
					
				update_country_info(country.name)
				play_blink_animation(country)
				_on_country_clicked(country.name, country.global_position)
				return

func play_blink_animation(sprite):
	animation_player.stop()  # Stop previous animations

	var anim_name = "blink_" + sprite.name  # Unique animation name per sprite

	if not animation_player.has_animation(anim_name):
		var anim = Animation.new()
		anim.add_track(Animation.TYPE_VALUE)
		anim.track_set_path(0, str(sprite.get_path()) + ":modulate:a")  # Fix path issue

		# Create blink effect (fade in and out)
		anim.track_insert_key(0, 0.0, 1.0)  # Fully visible
		anim.track_insert_key(0, 0.2, 0.3)  # Almost invisible
		anim.track_insert_key(0, 0.4, 1.0)  # Fully visible
		anim.track_insert_key(0, 0.6, 0.3)  # Almost invisible
		anim.track_insert_key(0, 0.8, 1.0)  # Fully visible

		anim.length = 5.0  # Duration of 1 second

		# Add animation to an AnimationLibrary before using it
		var anim_lib = animation_player.get_animation_library("")
		if anim_lib == null:
			anim_lib = AnimationLibrary.new()
			animation_player.add_animation_library("", anim_lib)

		anim_lib.add_animation(anim_name, anim)

	animation_player.play(anim_name)

func _on_country_clicked(country_name, mouse_pos):
	if activation_done:
		#print("⚠ Activation already done! Ignoring click on", country_name)
		return  

	selected_country = country_name
	
	print("✅ Country selected:", selected_country)

	# Find the country sprite dynamically
	var country_sprite = countries_container.find_child(country_name, true, false)
	if country_sprite:
		var sprite_rect = Rect2(
			-country_sprite.texture.get_width() / 2, 
			-country_sprite.texture.get_height() / 2, 
			country_sprite.texture.get_width(), 
			country_sprite.texture.get_height()
		)

		# **NEW FIX: Use center of country instead of mouse_pos**
		var center_local_pos = sprite_rect.get_center()  # Ensures we place the button at the middle
		var final_pos = country_sprite.to_global(center_local_pos)

		# Ensure button stays within country bounds
		final_pos.x = clamp(final_pos.x, country_sprite.global_position.x - sprite_rect.size.x / 2,
										   country_sprite.global_position.x + sprite_rect.size.x / 2)
		final_pos.y = clamp(final_pos.y, country_sprite.global_position.y - sprite_rect.size.y / 2,
										   country_sprite.global_position.y + sprite_rect.size.y / 2)

		# Position the activation button
		activation_button.global_position = final_pos
		activation_button.visible = true
		activation_button.mouse_filter = Control.MOUSE_FILTER_STOP
		print("✅ Activation Button Positioned at:", activation_button.global_position)
	#else:
		#print("❌ ERROR: Could not find sprite for", country_name)

# Modify _on_ActivationButton_pressed
# Add after initialize_media_states()
func print_unconnected_countries_status():
	var completely_unconnected = []
	
	for country_name in countries_data.get_all_country_names():
		var has_any_media = false
		for media_type in ["Print", "Satellite", "Social"]:
			if is_media_connected(country_name, media_type):
				has_any_media = true
				break
		
		if not has_any_media:
			completely_unconnected.append(country_name)
	
	if not completely_unconnected.is_empty():
		print("\n❌ Countries with NO media connections:")
		print(completely_unconnected)
		print("------------------------")

# Modify _on_ActivationButton_pressed()
func _on_ActivationButton_pressed():
	if not selected_country or activation_done:
		return

	print("\n🎯 ACTIVATION STARTED FROM:", selected_country)
	print("------------------------")
	
	activation_button.visible = false
	date_display.start_date_timer()

	if activation_sound:
		activation_sound.play()
	
	activation_marker.global_position = activation_button.global_position
	activation_marker.visible = true

	# Connect all media types immediately
	for media_type in ["Print", "Satellite", "Social"]:
		connect_media_to_hub(selected_country, media_type)
	
	# Schedule spreading
	schedule_media_connections(selected_country)
	retry_failed_connections()
	
	# Add periodic status check
	var status_timer = Timer.new()
	add_child(status_timer)
	status_timer.wait_time = 30.0  # Check every 30 seconds
	status_timer.timeout.connect(print_unconnected_countries_status)
	status_timer.start()
	
	activation_done = true

# Add new function to schedule media connections
func schedule_media_connections(country_name: String):
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 5.0  # 5 seconds for testing, adjust as needed
	timer.one_shot = true
	timer.timeout.connect(func(): start_spreading_to_neighbors(country_name))
	timer.start()

# Add these new variables at the top
var spreading_timer: Timer
# Modify the spread intervals
var PRINT_SPREAD_INTERVAL = 15.0    # Increased from 3.0
var SATELLITE_SPREAD_INTERVAL = 25.0  # Increased from 5.0
var SOCIAL_SPREAD_INTERVAL = 20.0    # Increased from 2.0

# Modify start_spreading_to_neighbors function
func start_spreading_to_neighbors(source_country: String):
	spreading_timer = Timer.new()
	add_child(spreading_timer)
	spreading_timer.wait_time = PRINT_SPREAD_INTERVAL
	spreading_timer.timeout.connect(func(): attempt_media_spread(source_country))
	spreading_timer.start()


# Add function to get spread intervals
# Remove the duplicate get_spread_interval function and modify the existing one
func get_spread_interval(media_type: String) -> float:
	var base_interval = 0.0
	match media_type:
		"Print":
			base_interval = PRINT_SPREAD_INTERVAL
		"Satellite":
			base_interval = SATELLITE_SPREAD_INTERVAL
		"Social":
			base_interval = SOCIAL_SPREAD_INTERVAL
		_:
			base_interval = PRINT_SPREAD_INTERVAL
	
	# Add some randomization to intervals
	return base_interval * randf_range(0.8, 1.2)

# Add this function to track connection statistics
func print_connection_stats():
	var stats = {
		"Print": {"connected": 0, "not_connected": 0},
		"Satellite": {"connected": 0, "not_connected": 0},
		"Social": {"connected": 0, "not_connected": 0}
	}
	
	for country in countries_data.get_all_country_names():
		for media_type in ["Print", "Satellite", "Social"]:
			if is_media_connected(country, media_type):
				stats[media_type]["connected"] += 1
			else:
				stats[media_type]["not_connected"] += 1
	
	print("\n📊 Connection Statistics:")
	#for media_type in stats:
		#print(media_type + ": " + str(stats[media_type]["connected"]) + " connected, " + 
			#  str(stats[media_type]["not_connected"]) + " not connected")
	#print("------------------------")

var pending_connections = []  # Add at the top with other variables

func queue_pending_connection(source_country: String, target_country: String, media_type: String):
	var connection_data = {
		"source": source_country,
		"target": target_country,
		"type": media_type
	}
	pending_connections.append(connection_data)
	#print("🕒 Queued connection for later: " + media_type + " from " + source_country + " to " + target_country)

# Move these functions outside of connect_media_to_media
func find_media_node(media_number: String, media_type: String) -> Node2D:
	var media_category = media_container.get_node_or_null(media_type)
	if media_category:
		return media_category.get_node_or_null(str(media_number))
	return null

func connect_media_to_hub(country_name: String, media_type: String):
	var media_info = countries_data.get_media_info(country_name, media_type)
	if media_info.is_empty():
		#print("⚠️ No media info found for", country_name, media_type)
		return
		
	var media_node = find_media_node(media_info["MediaNumber"], media_type)
	if not media_node or not media_node.visible:
		#print("⏳ Media not yet visible for " + media_type + " in " + country_name)
		return
		
	# Create connection to hub
	var connection_key = "hub_to_" + country_name + "_" + media_type
	if media_connections.has(connection_key):
		#print("⚠️ Hub connection already exists for " + country_name + " " + media_type)
		return
		
	var connection = Connection.new()
	# Use activation marker position instead of fixed coordinates
	connection.start_point = activation_marker.global_position
	connection.end_point = media_node.global_position
	connection.color = connection_colors[media_type]
	connection.progress = 1.0
	media_connections[connection_key] = connection
	add_child(connection)
	
	# Update media state
	set_media_state(country_name, media_type, true, true)
	print("✨ Connected " + media_type + " hub to " + country_name)

func retry_failed_connections():
	var retry_func = func():
		for country in countries_data.get_all_country_names():
			for media_type in ["Print", "Satellite", "Social"]:
				if not is_media_connected(country, media_type):
					attempt_media_spread(country)
	
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 5.0
	timer.timeout.connect(retry_func)
	timer.start()

# Modify connect_media_to_media function
func connect_media_to_media(source_country: String, target_country: String, media_type: String):
	# Get media numbers for both countries
	var source_media_number = get_media_number(source_country, media_type)
	var target_media_number = get_media_number(target_country, media_type)
	
	# Find the media nodes
	var source_media = find_media_node(source_media_number, media_type)
	var target_media = find_media_node(target_media_number, media_type)
	
	# Check if both nodes exist and are visible
	if source_media and target_media:
		if not source_media.visible or not target_media.visible:
			queue_pending_connection(source_country, target_country, media_type)
			return
			
		# Create unique connection key
		var connection_key = source_country + "_to_" + target_country + "_" + media_type
		if media_connections.has(connection_key):
			print("⚠️ Connection already exists between " + source_country + " and " + target_country + " for " + media_type)
			return
			
		# Create new connection
		var connection = Connection.new()
		connection.start_point = source_media.global_position
		connection.end_point = target_media.global_position
		connection.color = connection_colors[media_type]
		connection.progress = 1.0
		media_connections[connection_key] = connection
		add_child(connection)
		
		# Update media state
		set_media_state(target_country, media_type, true, true)
		print("✨ Connected " + media_type + " from " + source_country + " to " + target_country)
		
		# Debug unconnected countries
		var unconnected = []
		for country in countries_data.get_all_country_names():
			if not is_media_connected(country, media_type):
				unconnected.append(country)
		
		if not unconnected.is_empty():  # Changed from empty() to is_empty()
			print("\n🔍 Remaining unconnected countries for " + media_type + " (" + 
				  str(unconnected.size()) + "):")
			print(unconnected)
			print("------------------------")
	#else:
		#print("⏳ Cannot connect - media not visible or not found for " + media_type + 
			 # " between " + source_country + " and " + target_country)
# Modify calculate_spread_target for better spread mechanics
func calculate_spread_target(source_number: int, media_type: String) -> int:
	match media_type:
		"Print":
			# Print media prioritizes neighbors first
			if randf() < 0.8:  # 80% chance for nearby spread
				var possible_targets = []
				# Check immediate neighbors first
				for offset in [-1, 1]:
					var target = source_number + offset
					if target >= 1 and target <= 58:
						possible_targets.append(target)
				
				# If no immediate neighbors, try wider range
				if possible_targets.is_empty():  # Fixed: empty() -> is_empty()
					for offset in [-2, 2, -3, 3]:
						var target = source_number + offset
						if target >= 1 and target <= 58:
							possible_targets.append(target)
				
				if not possible_targets.is_empty():  # Fixed: empty() -> is_empty()
					return possible_targets[randi() % possible_targets.size()]
			return randi_range(1, 58)  # Global jump as fallback
			
		"Satellite":
			# Satellite spreads globally with high chance
			if randf() < 0.5:  # Increased from 0.6
				return randi_range(1, 58)
			else:
				var target = source_number + randi_range(-14, 14)  # Increased range
				return clamp(target, 1, 58) if target != source_number else -1
			
		"Social":
			# Social media spreads completely randomly
			return randi_range(1, 58)  # Always global spread
	
	return -1

func find_country_by_number(number: int) -> String:
	for country_name in countries_data.get_all_country_names():
		var data = countries_data.get_country_data(country_name)
		if data.get("CountryNumber", -1) == number:
			return country_name
	return ""

func is_media_connected(country: String, media_type: String) -> bool:
	var state = get_media_state(country, media_type)
	return state["connected"]


func _gui_input(event):
	
	if event is InputEventMouseButton and event.pressed:
		print("🖱️ Activation Button Clicked!")
		

func schedule_media_activation(media_number, media_type, days):
	if days <= 0:
		# Activate immediately for Early visibility
		activate_media(media_number, media_type)
		return
		
	var timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.wait_time = days * 10  # Convert days to seconds
	timer.timeout.connect(func(): activate_media(media_number, media_type))
	timer.start()

func initialize_government_timing():
	government_start_days = randi_range(250, 300)
	print("🏛️ Government will begin actions on day: " + str(government_start_days))

func update_government_progress(current_day):
	if current_day >= government_start_days:
		# Calculate speed based on influence (0-30 range)
		var influence_factor = influence_bar.value / 30.0
		var slowdown_multiplier = 1.0 - (influence_factor * 0.8)  # High influence = slower progress
		var daily_progress = base_government_speed * slowdown_multiplier
		
		government_progress = min(government_progress + daily_progress, 100.0)
		government_bar.value = government_progress
		
		if government_progress >= 100.0:
			print("⚠️ Government has reached full control!")
			show_result_panel("lose")

func initialize_media_visibility():
	# ✅ Show Print media immediately (Early: 0 days)
	for media_category in media_container.get_children():
		# Double the current scale of all media nodes
		for media_node in media_category.get_children():
			media_node.scale *= 1.8  # Multiply existing scale by 2
			
		if media_category.name == "Print":
			for media_node in media_category.get_children():
				media_node.visible = true
		else:
			for media_node in media_category.get_children():
				media_node.visible = false

	#print("✅ Initial Media Visibility Set (Print visible, others hidden).")

func activate_media(media_number, media_type):
	var media_category = media_container.get_node_or_null(media_type)
	if media_category:
		var media_node = media_category.get_node_or_null(str(media_number))
		if media_node:
			media_node.visible = true
			#print("✅ Successfully activated " + media_type + " " + str(media_number))
		else:
			push_error("❌ ERROR: Media node not found: " + str(media_number))
	else:
		push_error("❌ ERROR: Media category not found: " + media_type)

func hide_all_media():
	for media_category in media_container.get_children():  # Loop through "Print", "Satellite", "Social"
		for media_node in media_category.get_children():  # Loop through media inside the category
			media_node.visible = false
	print("✅ All media nodes are now hidden.")

func get_media_number(country_name, media_type):
	var country_data = countries_data.get_country_data(country_name)
	if country_data.is_empty():
		#print("❌ ERROR: No country found with name", country_name)
		return ""
	
	var country_number = str(country_data["CountryNumber"])
	match media_type:
		"Print": return country_number + "-1"
		"Satellite": return country_number + "-2"
		"Social": return country_number + "-3"
	
	#print("❌ ERROR: Invalid media type:", media_type)
	return ""

# ✅ Function to determine media visibility timing
func get_media_visibility_days(visibility, media_type):
	var base_days = 0
	
	match visibility:
		"Early":
			match media_type:
				"Print": base_days = randi_range(30, 60)      # 1-2 months
				"Satellite": base_days = randi_range(90, 150)  # 3-5 months
				"Social": base_days = randi_range(60, 120)    # 2-4 months
				_: base_days = randi_range(30, 60)
		"Moderate":
			match media_type:
				"Print": base_days = randi_range(180, 270)    # 6-9 months
				"Satellite": base_days = randi_range(240, 360) # 8-12 months
				"Social": base_days = randi_range(210, 300)   # 7-10 months
				_: base_days = randi_range(180, 270)
		"Late":
			match media_type:
				"Print": base_days = randi_range(400, 500)    # 13-16 months
				"Satellite": base_days = randi_range(480, 600) # 16-20 months
				"Social": base_days = randi_range(450, 550)   # 15-18 months
				_: base_days = randi_range(400, 500)
		"Limited":
			match media_type:
				"Print": base_days = randi_range(600, 720)    # 20-24 months
				"Satellite": base_days = randi_range(720, 900) # 24-30 months
				"Social": base_days = randi_range(660, 840)   # 22-28 months
				_: base_days = randi_range(600, 720)
		_:
			base_days = 0
	
	# Add more random variation (±30%)
	return int(base_days * randf_range(0.7, 1.3))

var active_media_states = {}

func initialize_media_states():
	active_media_states.clear()
	for country_name in countries_data.get_all_country_names():
		active_media_states[country_name] = {
			"Print": {"installed": false, "connected": false},
			"Satellite": {"installed": false, "connected": false},
			"Social": {"installed": false, "connected": false}
		}

func set_media_state(country_name: String, media_type: String, installed: bool, connected: bool):
	if country_name in active_media_states:
		active_media_states[country_name][media_type]["installed"] = installed
		active_media_states[country_name][media_type]["connected"] = connected

func get_media_state(country_name: String, media_type: String) -> Dictionary:
	if country_name in active_media_states:
		return active_media_states[country_name][media_type]
	return {"installed": false, "connected": false}

func update_country_info(country_name):
	var data = countries_data.get_country_data(country_name)
	
	if not data.is_empty():
		country_name_label.text = "Country: " + country_name
		population_label.text = "Population: " + str(data["Population"])
		# Convert followers to float and format it
		var followers = float(str(data["Followers"]).replace("%", ""))
		followers_label.text = "Followers: " + str(floorf(followers)) + "%"
		
		# Add media status to summary
		var media_status = "\n\nActive Media:"
		for media_type in ["Print", "Satellite", "Social"]:
			var state = get_media_state(country_name, media_type)
			if state["installed"] and state["connected"]:
				media_status += "\n- " + media_type
		
		summary_label.text = data["CountrySummary"] + media_status
		show_country_panel()
	
# Add at the top with other variables
var media_connections = {}  # Stores active connections
# Update the connection colors at the top with other variables
var connection_colors = {
	"Print": Color(0.1, 0.1, 0.1, 0.8),  # Black for Print
	"Satellite": Color(0.2, 0.4, 0.9, 0.8),  # Blue for Satellite
	"Social": Color(0.8, 0.7, 0.2, 0.8)  # Dark yellow for Social
}
# Modify the Connection class to return to the original style with thin dotted lines
class Connection extends Node2D:
	var start_point: Vector2
	var end_point: Vector2
	var color: Color
	var progress: float = 0.0
	var dot_spacing = 5.0  # Space between dots
	var line_width = 1.0   # Thin line

	func _ready():
		z_index = 49
		
	func _draw():
		if progress <= 0:
			return
			
		var direction = (end_point - start_point)
		var length = direction.length()
		var current_length = length * progress
		
		# Calculate number of dots needed
		var num_dots = int(current_length / dot_spacing)
		
		# Draw dotted line
		for i in range(num_dots):
			var t = float(i) / float(num_dots - 1)
			var dot_start = start_point.lerp(end_point, t)
			var dot_end = dot_start + direction.normalized() * 2  # 2 pixel dot length
			draw_line(dot_start, dot_end, color, line_width)
			

func update_followers_conversion():
	for country_name in countries_data.get_all_country_names():
		var country_data = countries_data.get_country_data(country_name)
		var active_media_count = 0
		var total_multiplier = 0.0
		
		# Calculate multiplier based on active media
		for media_type in ["Print", "Satellite", "Social"]:
			var media_state = get_media_state(country_name, media_type)
			if media_state["installed"] and media_state["connected"]:
				active_media_count += 1
				total_multiplier += media_multipliers[media_type]
		
		if active_media_count > 0:
			var current_followers = float(str(country_data["Followers"]).replace("%", ""))
			var influence_bonus = influence_bar.value / 30.0
			var believability_bonus = believability_bar.value / 30.0
			var exposure_multiplier = 1.0 + (exposure_bar.value / 30.0)
			
			var daily_conversion = conversion_rate_base * total_multiplier * (1 + influence_bonus) * (1 + believability_bonus) * exposure_multiplier
			
			var new_followers = min(current_followers + daily_conversion, 100.0)
			countries_data.update_followers(country_name, str(new_followers) + "%")

func update_global_stats():
	var total_followers_count = 0
	var total_countries = countries_data.get_all_country_names().size()
	
	for country_name in countries_data.get_all_country_names():
		var country_data = countries_data.get_country_data(country_name)
		var follower_percentage = float(str(country_data["Followers"]).replace("%", ""))
		total_followers_count += follower_percentage
	
	# Calculate total progress (0-100%)
	var total_progress = (total_followers_count / (total_countries * 100.0)) * 100.0
	global_followers = total_progress
	
	# Update UI
	update_stats_display()

# Add after update_stats_display function
func update_stats_display():
	# Update global stats in the stats container
	influence_value.text = str(floorf(influence_bar.value)) + "%"
	believability_value.text = str(floorf(believability_bar.value)) + "%"
	exposure_value.text = str(floorf(exposure_bar.value)) + "%"
	total_followers_bar.value = global_followers
	
	if global_followers >= 100.0:
		show_result_panel("win")
	elif exposure_bar.value >= 20:
		force_connect_remaining_countries()

func show_result_panel(result_type: String):
	if date_display and date_display.has_method("stop_timer"):
		date_display.stop_timer()
	
	if result_type == "win":
		result_text.text = "Victory!\nYour conspiracy has taken over the world!"
	else:
		result_text.text = "Game Over!\nThe government has stopped your conspiracy!"
	
	result_panel.visible = true
	result_panel.z_index = 110

func _on_replay_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/loading_screen.tscn")

# Add new function to force connect remaining countries
func force_connect_remaining_countries():
	var unconnected_countries = []
	
	# Find all unconnected countries
	for country_name in countries_data.get_all_country_names():
		for media_type in ["Print", "Satellite", "Social"]:
			if not is_media_connected(country_name, media_type):
				unconnected_countries.append({
					"country": country_name,
					"media_type": media_type
				})
	
	# Connect each unconnected country to the nearest connected country
	for unconnected in unconnected_countries:
		var nearest_connected = find_nearest_connected_country(
			unconnected["country"], 
			unconnected["media_type"]
		)
		
		if nearest_connected:
			connect_media_to_media(
				nearest_connected, 
				unconnected["country"], 
				unconnected["media_type"]
			)

# Add helper function to find nearest connected country
func find_nearest_connected_country(target_country: String, media_type: String) -> String:
	var target_number = int(countries_data.get_country_data(target_country)["CountryNumber"])
	var nearest_distance = 999
	var nearest_country = ""
	
	for country_name in countries_data.get_all_country_names():
		if country_name != target_country and is_media_connected(country_name, media_type):
			var country_number = int(countries_data.get_country_data(country_name)["CountryNumber"])
			var distance = abs(country_number - target_number)
			
			if distance < nearest_distance:
				nearest_distance = distance
				nearest_country = country_name
	
	return nearest_country

func _on_upgrade_button_pressed():
	upgrades_panel.visible = !upgrades_panel.visible

func _on_upgrade_purchased(upgrade_name: String, believability: float, exposure: float, influence: float, cost: int):
	var wallet = get_tree().get_nodes_in_group("wallet")[0]
	if wallet.spend_coins(cost):
		# Apply upgrades and update labels
		believability_bar.value += believability
		exposure_bar.value += exposure
		influence_bar.value += influence
		
		# Update the value labels
		believability_value.text = str(believability_bar.value)
		exposure_value.text = str(exposure_bar.value)
		influence_value.text = str(influence_bar.value)
		
		print("✅ Purchased upgrade: " + upgrade_name)
	else:
		print("❌ Not enough coins for: " + upgrade_name)
