extends Panel  # Change from Node2D to Panel

signal upgrade_purchased(upgrade_name, believability, exposure, influence, cost)

# Update the signal emission in _on_upgrade_button_pressed
func _on_upgrade_button_pressed(upgrade_name: String, category: String, data: Dictionary):
	if purchased_upgrades[category][upgrade_name]:
		return
		
	emit_signal("upgrade_purchased", upgrade_name, data["believability"], 
				data["exposure"], data["influence"], data["cost"])
	
	# Update the purchased state after successful emission
	purchased_upgrades[category][upgrade_name] = true

# Move purchased_upgrades declaration to the top with other variables
var purchased_upgrades = {}
var upgrades = {
	"spreading_power": {
		"Convincing Lies": {
			"description": "Boost the credibility of your conspiracy, making it more convincing to the public.",
			"believability": 3.0,
			"exposure": 0.0,
			"influence": 0.0,
			"cost": 3
		},
		"Fake Experts": {
			"description": "Create false experts to back up your theory with fake credentials and authority.",
			"believability": 4.0,
			"exposure": 0.0,
			"influence": 0.0,
			"cost": 5
		},
		"Brainwashing Techniques": {
			"description": "Use manipulative psychological tactics to make it easier for people to accept your theory.",
			"believability": 3.5,
			"exposure": 0.0,
			"influence": 0.0,
			"cost": 7
		},
		"Fear Mongering": {
			"description": "Use fear tactics to influence people to believe your conspiracy is true.",
			"believability": 2.0,
			"exposure": 0.0,
			"influence": 0.0,
			"cost": 5
		},
		"Echo Chambers": {
			"description": "Create online communities to reinforce and spread your message.",
			"believability": 3.0,
			"exposure": 1.0,
			"influence": 0.0,
			"cost": 7
		},
		"Religious Ties": {
			"description": "Tie your theory to religious beliefs to increase its credibility.",
			"believability": 2.5,
			"exposure": 0.0,
			"influence": 0.0,
			"cost": 7
		}
	},
	"media_control": {
		"Newspaper Bribes": {
			"description": "Pay journalists to promote your conspiracy as news in major publications.",
			"believability": 0.0,
			"exposure": 2.5,
			"influence": 0.0,
			"cost": 3
		},
		"Satellite Hijack": {
			"description": "Force TV channels to broadcast your message worldwide, ensuring a broad reach.",
			"believability": 0.0,
			"exposure": 3.0,
			"influence": 0.0,
			"cost": 5
		},
		"Viral Marketing": {
			"description": "Use algorithms to push your theory to millions on social media.",
			"believability": 0.0,
			"exposure": 3.0,
			"influence": 0.0,
			"cost": 7
		},
		"Meme Warfare": {
			"description": "Use memes to engage users and spread the conspiracy faster on social media.",
			"believability": 0.0,
			"exposure": 2.5,
			"influence": 0.0,
			"cost": 5
		},
		"Podcast Manipulation": {
			"description": "Use popular podcast influencers to discuss and promote your theory.",
			"believability": 0.0,
			"exposure": 2.0,
			"influence": 0.0,
			"cost": 7
		},
		"Celebrity Endorsements": {
			"description": "Pay famous people to publicly support and spread your conspiracy.",
			"believability": 0.0,
			"exposure": 4.0,
			"influence": 0.0,
			"cost": 12
		}
	},
	"government_resistance": {
		"Bribe Officials": {
			"description": "Pay off politicians to ignore or delay the government crackdown.",
			"believability": 0.0,
			"exposure": 0.0,
			"influence": 3.5,
			"cost": 5
		},
		"False Research Papers": {
			"description": "Publish fake scientific papers to bolster your theory's credibility.",
			"believability": 0.0,
			"exposure": 0.0,
			"influence": 2.5,
			"cost": 7
		},
		"Hacked TV Networks": {
			"description": "Take over TV networks to broadcast your message, even if it's banned.",
			"believability": 0.0,
			"exposure": 0.0,
			"influence": 4.5,
			"cost": 12
		},
		"Mass Protests": {
			"description": "Organize fake protests to divert attention away from debunkers.",
			"believability": 0.0,
			"exposure": 0.0,
			"influence": 4.0,
			"cost": 7
		},
		"Legal Loopholes": {
			"description": "Use loopholes in free speech laws to avoid censorship.",
			"believability": 0.0,
			"exposure": 0.0,
			"influence": 4.5,
			"cost": 5
		},
		"Alternative Platforms": {
			"description": "Use smaller, harder-to-ban platforms to keep the conspiracy alive.",
			"believability": 0.0,
			"exposure": 0.0,
			"influence": 3.5,
			"cost": 5
		}
	}
}

func _ready():
	initialize_purchased_upgrades()  # Initialize first
	setup_upgrade_buttons()          # Then setup buttons
	$CloseButton.pressed.connect(_on_close_button_pressed)

func initialize_purchased_upgrades():
	purchased_upgrades.clear()  # Clear any existing data
	for category in upgrades:
		purchased_upgrades[category] = {}
		for upgrade_name in upgrades[category]:
			purchased_upgrades[category][upgrade_name] = false

func setup_upgrade_buttons():
	for category in upgrades:
		# Get the correct container based on dictionary key
		var container_name = ""
		match category:
			"spreading_power": container_name = "SpreadingPower"
			"media_control": container_name = "MediaControl"
			"government_resistance": container_name = "GovernmentResistance"
		
		var category_container = $CategoryContainer.get_node(container_name)
		if category_container:
			# Create buttons for all upgrades in this category
			var upgrade_names = upgrades[category].keys()
			for i in range(upgrade_names.size()):
				var upgrade_name = upgrade_names[i]
				var button_name = "UpgradeButton" + str(i + 1)
				
				# Get or create button
				var button = category_container.get_node_or_null(button_name)
				if not button:
					button = Button.new()
					button.name = button_name
					category_container.add_child(button)
				
				setup_button(button, category, upgrade_name, upgrades[category][upgrade_name])

func setup_button(button: Button, category: String, upgrade_name: String, data: Dictionary):
	button.text = upgrade_name + "\nCost: " + str(data["cost"]) + " 💰"
	
	# Enhanced tooltip setup
	button.tooltip_text = data["description"]
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button.focus_mode = Control.FOCUS_ALL
	
	# Tooltip customization
	var tooltip_style = StyleBoxFlat.new()
	tooltip_style.bg_color = Color(1, 1, 1, 0.95)  # White background
	tooltip_style.border_color = Color(0.2, 0.2, 0.2)
	tooltip_style.border_width_left = 1
	tooltip_style.border_width_right = 1
	tooltip_style.border_width_top = 1
	tooltip_style.border_width_bottom = 1
	tooltip_style.corner_radius_top_left = 4
	tooltip_style.corner_radius_top_right = 4
	tooltip_style.corner_radius_bottom_left = 4
	tooltip_style.corner_radius_bottom_right = 4
	tooltip_style.content_margin_left = 8
	tooltip_style.content_margin_right = 8
	tooltip_style.content_margin_top = 8
	tooltip_style.content_margin_bottom = 8
	
	button.add_theme_stylebox_override("tooltip", tooltip_style)
	button.add_theme_color_override("tooltip_font_color", Color(0, 0, 0))  # Black text
	button.add_theme_font_size_override("tooltip_font_size", 16)  # Slightly larger font
	
	# Get wallet reference safely
	var wallet_nodes = get_tree().get_nodes_in_group("wallet")
	var current_coins = 0
	
	# Clear any existing connections to prevent duplicates
	if button.pressed.is_connected(Callable(self, "_on_upgrade_button_pressed")):
		button.pressed.disconnect(Callable(self, "_on_upgrade_button_pressed"))
	
	# Check if wallet exists and get coins
	if not wallet_nodes.is_empty():
		current_coins = wallet_nodes[0].get_coins()
	
	# Add stats to button text
	var stats = []
	if data["believability"] > 0:
		stats.append("Believability: +" + str(data["believability"]))
	if data["exposure"] > 0:
		stats.append("Exposure: +" + str(data["exposure"]))
	if data["influence"] > 0:
		stats.append("Influence: +" + str(data["influence"]))
	
	if not stats.is_empty():
		button.text += "\n" + "\n".join(stats)
	
	button.pressed.connect(_on_upgrade_button_pressed.bind(upgrade_name, category, data))

# Add this helper function at the bottom of the script
func create_stylebox(color: Color) -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.bg_color = color
	style.corner_radius_top_left = 5
	style.corner_radius_top_right = 5
	style.corner_radius_bottom_left = 5
	style.corner_radius_bottom_right = 5
	return style

func _on_close_button_pressed():
	visible = false
