extends Control

@onready var character_image = $CharacterImage
@onready var tap_continue = $TapToContinue
@onready var tap_detector = $TapDetector
var current_selection = 0
var can_continue = false

func _ready():
	setup_character_flicker()
	setup_buttons()
	setup_tap_continue()
	
	# Add tap detection to the root Control node
	gui_input.connect(_on_tap_detector_input)

func _on_tap_detector_input(event):
	if event is InputEventMouseButton and event.pressed and can_continue:
		get_tree().change_scene_to_file("res://CountryMap.tscn")

func setup_tap_continue():
	tap_continue.visible = false  # Hide initially
	tap_continue.modulate.a = 0

func _on_conspiracy_selected(conspiracy: String, index: int):
	current_selection = index
	# Update all buttons
	for i in range(3):
		var button = get_node("VBoxContainer/ConspiracyButton" + str(i + 1))
		update_button_style(button, i == current_selection)
	
	var game_state = get_node_or_null("/root/game_state")
	if game_state:
		game_state.selected_conspiracy = conspiracy
	
	# Show tap to continue after selection
	tap_continue.visible = true
	var tween = create_tween()
	tween.tween_property(tap_continue, "modulate:a", 1.0, 0.5)
	can_continue = true


# Remove the _input function as we're using tap_detector now
func setup_character_flicker():
	var flicker_tween = create_tween()
	flicker_tween.set_loops()
	flicker_tween.tween_property(character_image, "modulate:a", 0.7, 0.1)
	flicker_tween.tween_property(character_image, "modulate:a", 1.0, 0.1)



func setup_buttons():
	var conspiracies = [
		{
			"name": "Birds Aren't Real: The Escape of a Spy Pigeon",
			"selected": true
		},
		{
			"name": "The Moon is a Hologram: What Lies Beneath?",
			"selected": false
		},
		{
			"name": "Cats: Interdimensional Observers",
			"selected": false
		}
	]
	
	for i in range(conspiracies.size()):
		var button = get_node("VBoxContainer/ConspiracyButton" + str(i + 1))
		setup_conspiracy_button(button, conspiracies[i], i)

func setup_conspiracy_button(button: Button, data: Dictionary, index: int):
	button.text = data["name"]
	update_button_style(button, index == current_selection)
	button.pressed.connect(_on_conspiracy_selected.bind(data["name"], index))

func update_button_style(button: Button, is_selected: bool):
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.2, 0.4, 0.2, 0.8) if is_selected else Color(0.1, 0.2, 0.1, 0.8)
	style.corner_radius_top_left = 10
	style.corner_radius_top_right = 10
	style.corner_radius_bottom_left = 10
	style.corner_radius_bottom_right = 10
	button.add_theme_stylebox_override("normal", style)
	button.custom_minimum_size = Vector2(600, 80)
	button.add_theme_font_size_override("font_size", 24)
