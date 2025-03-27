extends Node2D

signal day_changed(day)

@onready var country_info_panel = $"CanvasLayer/CountryInfoPanel"
@onready var country_name_label = $"CanvasLayer/CountryInfoPanel/CountryName"
@onready var population_label = $"CanvasLayer/CountryInfoPanel/Population"
@onready var followers_label = $"CanvasLayer/CountryInfoPanel/Followers"
@onready var summary_label = $"CanvasLayer/CountryInfoPanel/Summary"

@onready var countries_container = $CountriesContainer

@onready var animation_player = $CountriesContainer/AnimationPlayer

# For date calling from the DateDisplay.gd
@onready var date_display = $Calender/DateDisplay

var selected_country = null  # Track the selected country
var activation_done = false  # Prevents multiple activations

@onready var activation_button = $ActivationButton  # The activation button
@onready var activation_marker = $ActivationMarker  # The activation sprite

@onready var media_container = get_node("MediaContainer")

var button_offset := Vector2(0, -10)

# At the top with other variables
@onready var countries_data = preload("res://scripts/countries_data.gd").new()

# Replace direct dictionary access with method calls
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

# In _on_day_changed function
func _on_day_changed(total_days):
	print("📅 Day changed to: ", total_days)
	
	for country_name in countries_data.get_all_country_names():
		for media_type in ["Satellite", "Social"]:
			var media_info = countries_data.get_media_info(country_name, media_type)
			var media_state = get_media_state(country_name, media_type)
			
			if not media_info.is_empty() and not media_state["installed"]:
				var days_needed = get_media_visibility_days(media_info["Visibility"], media_type)
				print("🔍 Checking " + media_type + " for " + country_name + 
					  " (needs " + str(days_needed) + " days, current: " + str(total_days) + ")")
				
				if total_days >= days_needed:
					activate_media(media_info["MediaNumber"], media_type)
					set_media_state(country_name, media_type, true, false)
					print("✅ Activated " + media_type + " for " + country_name)


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
				# Show country info
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
		print("⚠ Activation already done! Ignoring click on", country_name)
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
	else:
		print("❌ ERROR: Could not find sprite for", country_name)

func _on_ActivationButton_pressed():
	
	if not selected_country:
		print("⚠️ No country selected!")
		return

	if activation_done:
		print("⚠️ Activation already completed!")
		return

	print("🚀 Activating:", selected_country)

	# Hide activation button
	activation_button.visible = false
	
	date_display.start_date_timer()

	# Find country sprite & place marker
	var country_sprite = countries_container.find_child(selected_country, true, false)
	if country_sprite:
		
		var sprite_rect = Rect2(
			-country_sprite.texture.get_width() / 2, 
			-country_sprite.texture.get_height() / 2, 
			country_sprite.texture.get_width(), 
			country_sprite.texture.get_height()
		)
		
		# Place marker at the center
		var marker_position = country_sprite.to_global(sprite_rect.get_center())
		activation_marker.global_position = marker_position
		activation_marker.visible = true

		# Extra Debugging
		if not activation_marker.visible:
			print("⚠️ ERROR: Activation Marker is STILL hidden!")
		else:
			print("✅ Activation Marker is now VISIBLE!")

	else:
		print("❌ ERROR: Could not find country sprite for marker placement!")

	# Prevent multiple activations
	activation_done = true
		
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


func initialize_media_visibility():
	# ✅ Show Print media immediately (Early: 0 days)
	for media_category in media_container.get_children():
		if media_category.name == "Print":
			for media_node in media_category.get_children():
				media_node.visible = true  # Print media is always available at start
		else:
			for media_node in media_category.get_children():
				media_node.visible = false  # Hide other media

	print("✅ Initial Media Visibility Set (Print visible, others hidden).")

func activate_media(media_number, media_type):
	var media_category = media_container.get_node_or_null(media_type)
	if media_category:
		var media_node = media_category.get_node_or_null(str(media_number))
		if media_node:
			media_node.visible = true
			print("✅ Successfully activated " + media_type + " " + str(media_number))
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
		print("❌ ERROR: No country found with name", country_name)
		return ""
	
	var country_number = str(country_data["CountryNumber"])
	match media_type:
		"Print": return country_number + "-1"
		"Satellite": return country_number + "-2"
		"Social": return country_number + "-3"
	
	print("❌ ERROR: Invalid media type:", media_type)
	return ""

# ✅ Function to determine media visibility timing
func get_media_visibility_days(visibility, media_type):
	match visibility:
		"Early":
			return randi_range(50, 100)  # 50-200 days
		"Moderate":
			return randi_range(100, 300)  # 500-1000 days
		"Late":
			return randi_range(350, 500)  # 1500-2500 days
		"Limited":
			return randi_range(500, 600)  # 3000-4000 days
	return 0

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
	print("🔍 Updating info for country:", country_name)
	var data = countries_data.get_country_data(country_name)
	print("📊 Retrieved data:", data)
	
	if not data.is_empty():
		# ✅ Update UI
		country_name_label.text = "Country: " + country_name
		population_label.text = "Population: " + str(data["Population"])
		followers_label.text = "Followers: " + str(data["Followers"]) + "%"
		summary_label.text = data["CountrySummary"]
		country_info_panel.visible = true
		print("✅ UI updated successfully")
	else:
		push_error("⚠️ No data available for " + country_name)
	
	# Debug country data
	print("📊 Available countries:", countries_data.get_all_country_names())
	
	# Test data access for a specific country
	var test_country = countries_data.get_all_country_names()[0]
	var test_data = countries_data.get_country_data(test_country)
	print("📊 Test country data for", test_country, ":", test_data)
