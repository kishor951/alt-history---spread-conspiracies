extends Area2D

@export var coin_value: int = 1
var collected = false
var fall_speed = 200.0
var target_position: Vector2

@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D

func _ready():
	# Set random spawn position from different directions
	var viewport = get_tree().root.get_viewport()
	var viewport_size = viewport.get_visible_rect().size
	
	# Random spawn direction (0: top, 1: right, 2: bottom, 3: left)
	var spawn_direction = randi() % 4
	
	match spawn_direction:
		0: # Top
			position = Vector2(
				randf_range(100, viewport_size.x - 100),
				-50
			)
		1: # Right
			position = Vector2(
				viewport_size.x + 50,
				randf_range(100, viewport_size.y - 100)
			)
		2: # Bottom
			position = Vector2(
				randf_range(100, viewport_size.x - 100),
				viewport_size.y + 50
			)
		3: # Left
			position = Vector2(
				-50,
				randf_range(100, viewport_size.y - 100)
			)
	
	# Set random target position near center
	target_position = Vector2(
		randf_range(viewport_size.x * 0.3, viewport_size.x * 0.7),
		randf_range(viewport_size.y * 0.3, viewport_size.y * 0.7)
	)
	
	# Connect input event
	input_event.connect(_on_input_event)
	
	# Start blinking
	create_blink_animation()

func _physics_process(delta):
	if not collected and position.distance_to(target_position) > 5:
		position = position.move_toward(target_position, fall_speed * delta)

func create_blink_animation():
	var anim = Animation.new()
	anim.length = 0.6
	anim.loop_mode = Animation.LOOP_LINEAR
	
	# Create animation library if it doesn't exist
	var lib_name = "coin_animations"
	if not animation_player.has_animation_library(lib_name):
		var new_lib = AnimationLibrary.new()
		animation_player.add_animation_library(lib_name, new_lib)
	
	var track_idx = anim.add_track(Animation.TYPE_VALUE)
	anim.track_set_path(track_idx, ".:modulate:a")
	anim.track_insert_key(track_idx, 0.0, 1.0)
	anim.track_insert_key(track_idx, 0.3, 0.3)
	anim.track_insert_key(track_idx, 0.6, 1.0)
	
	animation_player.get_animation_library(lib_name).add_animation("blink", anim)
	animation_player.play("coin_animations/blink")
	
	# Start fade timer
	await get_tree().create_timer(5.0).timeout
	if not collected:
		fade_out()

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and not collected:
		collect_coin()

func collect_coin():
	if collected: return
	collected = true
	
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.1)
	tween.tween_property(self, "modulate:a", 0.0, 0.2)
	tween.tween_callback(func():
		get_tree().call_group("wallet", "add_coins", coin_value)
		queue_free()
	)

func fade_out():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	tween.tween_callback(queue_free)
