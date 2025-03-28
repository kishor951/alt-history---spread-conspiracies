extends Panel

signal upgrade_purchased(upgrade_name, category, cost)

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
			"believability": 2.0,
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
	setup_upgrade_buttons()
	initialize_purchased_upgrades()

func setup_upgrade_buttons():
	for category in upgrades:
		var category_container = get_node(category.capitalize())
		if category_container:
			for upgrade_name in upgrades[category]:
				create_upgrade_button(category_container, upgrade_name, upgrades[category][upgrade_name])

# Add at the top with other variables
var purchased_upgrades = {}

func initialize_purchased_upgrades():
	for category in upgrades:
		purchased_upgrades[category] = {}
		for upgrade_name in upgrades[category]:
			purchased_upgrades[category][upgrade_name] = false

func create_upgrade_button(container: Control, upgrade_name: String, data: Dictionary):
	var button = Button.new()
	button.text = upgrade_name + "\nCost: " + str(data["cost"]) + " 💰"
	button.tooltip_text = data["description"]
	button.custom_minimum_size = Vector2(200, 80)
	
	# Add purchased state visual
	if purchased_upgrades[category][upgrade_name]:
		button.disabled = true
		button.text += "\n(Purchased)"
	
	var stats = []
	if data["believability"] > 0:
		stats.append("Believability: +" + str(data["believability"]))
	if data["exposure"] > 0:
		stats.append("Exposure: +" + str(data["exposure"]))
	if data["influence"] > 0:
		stats.append("Influence: +" + str(data["influence"]))
	
	if not stats.empty():
		button.text += "\n" + "\n".join(stats)
	
	button.pressed.connect(_on_upgrade_button_pressed.bind(upgrade_name, category, data))
	container.add_child(button)

func _on_upgrade_button_pressed(upgrade_name: String, category: String, data: Dictionary):
	if purchased_upgrades[category][upgrade_name]:
		return
		
	emit_signal("upgrade_purchased", upgrade_name, data["believability"], data["exposure"], data["influence"], data["cost"])
