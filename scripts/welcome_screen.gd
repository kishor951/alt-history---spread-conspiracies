extends Control

@onready var welcome_message = $WelcomeMessage
@onready var tap_continue = $TapToContinue
@onready var character_image = $CharacterImage

var full_message = "Welcome to the Secret Society, Chief! \nLead the operations and let's rewrite the history \nand make people believe them 😈"
var current_char = 0
var typing_speed = 0.05
var can_continue = false  # Add this at the class level

func _ready():
	tap_continue.visible = false
	setup_initial_state()
	
	# Add tap detection to the root Control node
	gui_input.connect(_on_tap_detector_input)

func setup_initial_state():
	welcome_message.text = ""
	welcome_message.modulate.a = 1.0
	
	# Start character flicker
	var flicker_tween = create_tween()
	flicker_tween.set_loops()
	flicker_tween.tween_property(character_image, "modulate:a", 0.7, 0.1)
	flicker_tween.tween_property(character_image, "modulate:a", 1.0, 0.1)
	
	# Start typing animation
	start_typing_animation()

func start_typing_animation():
	var typing_timer = Timer.new()
	add_child(typing_timer)
	typing_timer.wait_time = typing_speed
	typing_timer.timeout.connect(_on_typing_timer_timeout.bind(typing_timer))
	typing_timer.start()

func _on_typing_timer_timeout(timer: Timer):
	if current_char < full_message.length():
		welcome_message.text += full_message[current_char]
		current_char += 1
	else:
		timer.stop()
		timer.queue_free()
		show_tap_continue()

func show_tap_continue():
	tap_continue.visible = true
	var tween = create_tween()
	tween.tween_property(tap_continue, "modulate:a", 1.0, 0.5)
	can_continue = true  # Set it to true here instead of declaring a new variable

func _on_tap_detector_input(event):
	if event is InputEventMouseButton and event.pressed and can_continue:
		get_tree().change_scene_to_file("res://scenes/conspiracy_selection.tscn")
