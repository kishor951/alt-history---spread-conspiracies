extends Control

# Add AudioStreamPlayer at the top with other @onready vars
@onready var button_sound = $ButtonSound
@onready var splash_sound = $SplashSound
@onready var alt_history = $AltHistory
@onready var subline = $Subline
@onready var big_splash = $BigSplash
@onready var drops1 = $Drops1
@onready var drops2 = $Drops2
@onready var loading = $Loading
@onready var enter_button = $Enter

func _ready():
	enter_button.visible = false
	enter_button.modulate.a = 0
	enter_button.pressed.connect(_on_enter_pressed)
	animate_sequence()

func animate_sequence():
	# Reset initial states
	alt_history.modulate.a = 0
	alt_history.scale = Vector2(0.1, 0.1)
	subline.modulate.a = 0
	big_splash.modulate.a = 0
	big_splash.scale = Vector2(0.1, 0.1)
	drops1.modulate.a = 0
	drops1.scale = Vector2(0.1, 0.1)
	drops2.modulate.a = 0
	drops2.scale = Vector2(0.1, 0.1)
	loading.modulate.a = 0
	
	var tween = create_tween()
	tween.set_parallel(false)
	
	# Longer delay before title appears
	tween.tween_interval(1.0)
	
	# Slower title animation
	tween.tween_property(alt_history, "scale", Vector2(1, 1), 1.5)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(alt_history, "modulate:a", 1.0, 1.5)
	
	# Play sound 2 seconds before splash
	tween.tween_callback(func(): splash_sound.play())
	tween.tween_interval(2.5)
	
	# Splash grows from small to large
	tween.tween_property(big_splash, "scale", Vector2(1, 1), 0.5)\
		.set_trans(Tween.TRANS_BOUNCE)
	tween.parallel().tween_property(big_splash, "modulate:a", 1.0, 0.5)
	
	# Drops grow and spread
	tween.tween_interval(0.3)
	tween.tween_property(drops1, "scale", Vector2(1, 1), 0.8)\
		.set_trans(Tween.TRANS_ELASTIC)
	tween.parallel().tween_property(drops1, "modulate:a", 1.0, 0.8)
	
	tween.tween_interval(0.2)
	tween.tween_property(drops2, "scale", Vector2(1, 1), 0.8)\
		.set_trans(Tween.TRANS_ELASTIC)
	tween.parallel().tween_property(drops2, "modulate:a", 1.0, 0.8)
	
	# Rest of the animations remain the same
	tween.tween_interval(0.4)
	tween.tween_property(subline, "modulate:a", 1.0, 0.5)
	tween.tween_callback(start_loading_blink)
	tween.tween_interval(3.0)  # Wait longer before showing enter
	tween.tween_callback(show_enter_button)  # Show enter button instead of changing scene
	
	# Remove the change_to_main_menu call
	tween.tween_interval(2.0)
	tween.tween_callback(change_to_main_menu)

func start_loading_blink():
	loading.visible = true
	var blink_tween = create_tween()
	blink_tween.set_loops()
	blink_tween.tween_property(loading, "modulate:a", 1.0, 0.5)
	blink_tween.tween_property(loading, "modulate:a", 0.2, 0.5)

func change_to_main_menu():
	# Change to main menu scene
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func show_enter_button():
	loading.visible = false  # Hide loading text
	enter_button.visible = true
	
	var button_tween = create_tween()
	button_tween.tween_property(enter_button, "modulate:a", 1.0, 1.0)

func _on_enter_pressed():
	button_sound.play()
	# Wait a brief moment for the sound to play before transitioning
	await get_tree().create_timer(0.1).timeout
	# Transition to welcome screen
	get_tree().change_scene_to_file("res://scenes/welcome_screen.tscn")
