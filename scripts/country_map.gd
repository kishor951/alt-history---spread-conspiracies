extends Node2D

@onready var country_info_panel = $"CanvasLayer/CountryInfoPanel"
@onready var country_name_label = $"CanvasLayer/CountryInfoPanel/CountryName"
@onready var population_label = $"CanvasLayer/CountryInfoPanel/Population"
@onready var resistors_label = $"CanvasLayer/CountryInfoPanel/Resistors"
@onready var followers_label = $"CanvasLayer/CountryInfoPanel/Followers"
@onready var summary_label = $"CanvasLayer/CountryInfoPanel/Summary"

@onready var countries_container = $CountriesContainer

@onready var animation_player = $CountriesContainer/AnimationPlayer

# For date calling from the DateDisplay.gd
@onready var date_display = $Calender/DateDisplay

var selected_country = null  # Track the selected country
var activation_done = false  # Prevents multiple activations

@onready var activation_button = $ActivationButton  # The activation button
@onready var marker_container = $MarkerContainer  # Holds markers
@onready var activation_marker = $ActivationMarker  # The activation sprite

var button_offset := Vector2(0, -30)

var countries_data = {
	"Brazil": {
		"population": 210571282,
		"resistors": 100,
		"followers": 0,
		"summary": "High political instability aids conspiracy growth."
	},
	"Colombia": {
		"population": 94464490,
		"resistors": 100,
		"followers": 0,
		"summary": "Unstable regions create easy misinformation spread."
	},
	"Argentina": {
		"population": 59065954,
		"resistors": 100,
		"followers": 0,
		"summary": "Economic uncertainty helps misinformation spread."
	},
	"Peru": {
		"population": 30375603,
		"resistors": 100,
		"followers": 0,
		"summary": "Political distrust creates receptive environment."
	},
	"Bolivia": {
		"population": 10671200,
		"resistors": 100,
		"followers": 0,
		"summary": "Political polarization creates receptive demographics."
	},
	"Australia": {
		"population": 23130900,
		"resistors": 100,
		"followers": 0,
		"summary": "High media literacy but isolated communities more susceptible."
	},
	"New Guinea": {
		"population": 7321262,
		"resistors": 100,
		"followers": 0,
		"summary": "Geographic isolation makes spread difficult but local beliefs strong."
	},
	"New Zealand": {
		"population": 4470800,
		"resistors": 100,
		"followers": 0,
		"summary": "High media literacy but isolated communities more susceptible."
	},
	"USA": {
		"population": 316128839,
		"resistors": 100,
		"followers": 0,
		"summary": "Fastest media spread but highest resistance from fact-checkers."
	},
	"Mexico": {
		"population": 122332399,
		"resistors": 100,
		"followers": 0,
		"summary": "High urban acceptance, rural regions harder to convert."
	},
	"Central America": {
		"population": 44723159,
		"resistors": 100,
		"followers": 0,
		"summary": "Social media popularity aids rapid spread in urban areas."
	},
	"Caribbean": {
		"population": 38316937,
		"resistors": 100,
		"followers": 0,
		"summary": "Island isolation can accelerate adoption once introduced."
	},
	"Canada": {
		"population": 35158304,
		"resistors": 100,
		"followers": 0,
		"summary": "High media literacy creates strong initial resistance."
	},
	"Greenland": {
		"population": 56483,
		"resistors": 100,
		"followers": 0,
		"summary": "Geographic isolation limits spread but creates strong local beliefs once established."
	},
	"Saudi Arabia": {
		"population": 71752069,
		"resistors": 100,
		"followers": 0,
		"summary": "Government-controlled media makes resistance high."
	},
	"Middle east": {
		"population": 46000846,
		"resistors": 100,
		"followers": 0,
		"summary": "Religious and political tensions make certain conspiracies spread rapidly."
	},
	"Iraq": {
		"population": 33417476,
		"resistors": 100,
		"followers": 0,
		"summary": "Social and political instability aids conspiracy spread."
	},
	"Russia": {
		"population": 160369925,
		"resistors": 100,
		"followers": 0,
		"summary": "State-controlled media limits growth but once adopted, spreads strongly."
	},
	"Turkey": {
		"population": 74932641,
		"resistors": 100,
		"followers": 0,
		"summary": "Political instability aids misinformation."
	},
	"Germany": {
		"population": 103039718,
		"resistors": 100,
		"followers": 0,
		"summary": "Highly skeptical society makes conversion tough."
	},
	"France": {
		"population": 77766807,
		"resistors": 100,
		"followers": 0,
		"summary": "Strong public scrutiny makes conversion harder."
	},
	"UK": {
		"population": 68692366,
		"resistors": 100,
		"followers": 0,
		"summary": "Fact-checking culture makes growth slow but effective once spread."
	},
	"Balkan States": {
		"population": 62285010,
		"resistors": 100,
		"followers": 0,
		"summary": "Political fragmentation creates opportunities for misinformation."
	},
	"Italy": {
		"population": 59831093,
		"resistors": 100,
		"followers": 0,
		"summary": "Historical conspiracies make storytelling easier."
	},
	"Spain": {
		"population": 57107227,
		"resistors": 100,
		"followers": 0,
		"summary": "Trust in traditional media delays spread."
	},
	"Ukraine": {
		"population": 45489600,
		"resistors": 100,
		"followers": 0,
		"summary": "Information warfare makes population receptive to conspiracy theories."
	},
	"Central Europe": {
		"population": 44448562,
		"resistors": 100,
		"followers": 0,
		"summary": "Education levels create initial resistance but can be overcome."
	},
	"Poland": {
		"population": 38530725,
		"resistors": 100,
		"followers": 0,
		"summary": "Traditional media still influential, slowing initial spread."
	},
	"Baltic States": {
		"population": 15760118,
		"resistors": 100,
		"followers": 0,
		"summary": "High digital literacy creates strong initial resistance."
	},
	"Sweden": {
		"population": 9592552,
		"resistors": 100,
		"followers": 0,
		"summary": "High media literacy and trust in institutions creates strong resistance."
	},
	"Finland": {
		"population": 5439407,
		"resistors": 100,
		"followers": 0,
		"summary": "High education levels create strong initial resistance."
	},
	"Norway": {
		"population": 5084190,
		"resistors": 100,
		"followers": 0,
		"summary": "High trust in institutions creates significant resistance."
	},
	"Iceland": {
		"population": 323002,
		"resistors": 100,
		"followers": 0,
		"summary": "Highly educated population with strong resistance to misinformation."
	},
	"India": {
		"population": 1457015015,
		"resistors": 100,
		"followers": 0,
		"summary": "Rapid social media spread but high government oversight."
	},
	"China": {
		"population": 1413227603,
		"resistors": 100,
		"followers": 0,
		"summary": "High censorship makes spreading difficult, but huge population potential."
	},
	"S E Asia": {
		"population": 261600281,
		"resistors": 100,
		"followers": 0,
		"summary": "Rapid adoption in urban areas; rural regions resist."
	},
	"Indonesia": {
		"population": 255264831,
		"resistors": 100,
		"followers": 0,
		"summary": "Social media fuels conspiracy spread."
	},
	"Pakistan": {
		"population": 182142594,
		"resistors": 100,
		"followers": 0,
		"summary": "Conservative society slows spread but media can accelerate."
	},
	"Japan": {
		"population": 127338621,
		"resistors": 100,
		"followers": 0,
		"summary": "Tech-savvy but skeptical society makes slow adoption."
	},
	"Philippines": {
		"population": 98393574,
		"resistors": 100,
		"followers": 0,
		"summary": "Social media dominance makes fast spread possible."
	},
	"Iran": {
		"population": 77447168,
		"resistors": 100,
		"followers": 0,
		"summary": "Censorship limits initial growth but can be subverted over time."
	},
	"Korea": {
		"population": 75115149,
		"resistors": 100,
		"followers": 0,
		"summary": "Highly digital society allows for rapid social media spread."
	},
	"Central Asia": {
		"population": 49408506,
		"resistors": 100,
		"followers": 0,
		"summary": "Limited media freedom but conspiracy narratives can resonate."
	},
	"Afghanistan": {
		"population": 30551674,
		"resistors": 100,
		"followers": 0,
		"summary": "Limited media access but strong word-of-mouth networks."
	},
	"Kazakhstan": {
		"population": 17037508,
		"resistors": 100,
		"followers": 0,
		"summary": "State media control limits initial spread but strong potential."
	},
	"West Africa": {
		"population": 330752285,
		"resistors": 100,
		"followers": 0,
		"summary": "Rural areas slow conversion; weak media presence."
	},
	"East Africa": {
		"population": 320789180,
		"resistors": 100,
		"followers": 0,
		"summary": "Similar to West Africa, limited connectivity."
	},
	"Central Africa": {
		"population": 114085724,
		"resistors": 100,
		"followers": 0,
		"summary": "Limited media makes it harder to spread."
	},
	"Egypt": {
		"population": 82056398,
		"resistors": 100,
		"followers": 0,
		"summary": "Religious influence makes spreading easier through certain groups."
	},
	"South Africa": {
		"population": 56534820,
		"resistors": 100,
		"followers": 0,
		"summary": "Divided social groups lead to mixed adoption rates."
	},
	"Algeria": {
		"population": 50094694,
		"resistors": 100,
		"followers": 0,
		"summary": "Cultural barriers slow initial spread."
	},
	"Sudan": {
		"population": 49260479,
		"resistors": 100,
		"followers": 0,
		"summary": "Ongoing conflicts create fertile ground for conspiracy theories."
	},
	"Morocco": {
		"population": 33008150,
		"resistors": 100,
		"followers": 0,
		"summary": "Urban-rural divide creates varied adoption rates."
	},
	"Madagascar": {
		"population": 22924851,
		"resistors": 100,
		"followers": 0,
		"summary": "Geographic isolation limits initial spread but strengthens local beliefs."
	},
	"Angola": {
		"population": 21471618,
		"resistors": 100,
		"followers": 0,
		"summary": "Limited infrastructure slows digital spread."
	},
	"Zimbabwe": {
		"population": 14149648,
		"resistors": 100,
		"followers": 0,
		"summary": "Political instability makes population receptive to alternative narratives."
	},
	"Libya": {
		"population": 6201521,
		"resistors": 100,
		"followers": 0,
		"summary": "Political instability creates receptive environment for conspiracy theories."
	},
	"Botswana": {
		"population": 2021144,
		"resistors": 100,
		"followers": 0,
		"summary": "Small population but high literacy makes careful targeting necessary."
	}
};

func _ready():
	var panel = get_tree().get_root().find_child("CountryInfoPanel", true, false)
	if panel:
		print("✅ CountryInfoPanel found at runtime!")
	else:
		print("❌ ERROR: CountryInfoPanel is NOT in the scene!")
	date_display.set_game_speed(1)
	
	print("🛠 Activation Button Check")
	
	if activation_button:
		print("✅ Activation Button Loaded")
	else:
		print("❌ Activation Button NOT Found")

	if activation_button.visible:
		print("✅ Activation Button is Visible")
	else:
		print("⚠️ Activation Button is Hidden!")
	
	print("🖱 Mouse Filter:", activation_button.mouse_filter)
	activation_button.connect("pressed", Callable(self, "_on_ActivationButton_pressed"))
	print("✅ Activation Button signal connected!")
	activation_marker.visible = false


func _input(event):
	if event is InputEventMouseButton and event.pressed:
		print("🖱️ Mouse clicked at:", event.position)
		check_country_click(event.position)

func check_country_click(mouse_pos):
	print("🔍 Checking countries...") 

	for country in countries_container.get_children():
		if country is Sprite2D:
			print("🖼 Checking sprite:", country.name)

			var local_pos = country.to_local(mouse_pos)
			print("📍 Local Position:", local_pos, "in", country.name)

			var sprite_rect = Rect2(
				-country.texture.get_width() / 2, 
				-country.texture.get_height() / 2, 
				country.texture.get_width(), 
				country.texture.get_height()
			)

			print("🖼 Sprite Bounds:", sprite_rect)

			if sprite_rect.has_point(local_pos):
				print("✅ Click is inside sprite bounds for", country.name)

				# Show country info
				update_country_info(country.name)
				play_blink_animation(country)
				_on_country_clicked(country.name, country.global_position)

		
				return

	print("❌ No country detected at:", mouse_pos)

func update_country_info(country_name):
	if country_name in countries_data:
		var data = countries_data[country_name]
		print("📢 Updating UI for:", country_name)

		# Update UI labels
		country_name_label.text = "Country: " + country_name
		population_label.text = "Population: " + str(data["population"])
		resistors_label.text = "Resistors: " + str(data["resistors"]) + "%"
		followers_label.text = "Followers: " + str(data["followers"]) + "%"
		summary_label.text = data["summary"]
		country_info_panel.visible = true  # Show the panel

	else:
		print("⚠️ No data available for", country_name)

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
	print("🔹 Activation Button was clicked!")  

	if not selected_country:
		print("⚠️ No country selected!")
		return

	if activation_done:
		print("⚠️ Activation already completed!")
		return

	print("🚀 Activating:", selected_country)

	# Hide activation button
	activation_button.visible = false
	print("👀 Activation Button Hidden")

	# Find country sprite & place marker
	var country_sprite = countries_container.find_child(selected_country, true, false)
	if country_sprite:
		print("✅ Found sprite for", selected_country)
		
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
		
		print("🌟 Activation Marker placed at:", activation_marker.global_position)
		print("🔍 Activation Marker Visibility:", activation_marker.visible)

		# Extra Debugging
		if not activation_marker.visible:
			print("⚠️ ERROR: Activation Marker is STILL hidden!")
		else:
			print("✅ Activation Marker is now VISIBLE!")

	else:
		print("❌ ERROR: Could not find country sprite for marker placement!")

	# Prevent multiple activations
	activation_done = true
	print("✅ Activation Done!")



		
func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		print("🖱️ Activation Button Clicked!")
