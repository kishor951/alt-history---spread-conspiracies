extends Node

@export var coin_scene: PackedScene
var can_spawn = true
var rng = RandomNumberGenerator.new()
var days_until_next_spawn = 0

func _ready():
	rng.randomize()
	set_next_spawn_day()
	get_tree().get_root().find_child("DateDisplay", true, false).connect("day_changed", _on_day_changed)

func set_next_spawn_day():
	days_until_next_spawn = rng.randi_range(20, 25)

func _on_day_changed(total_days):
	if days_until_next_spawn <= 0:
		spawn_coin()
		set_next_spawn_day()
	else:
		days_until_next_spawn -= 1

func spawn_coin():
	if not coin_scene or not can_spawn:
		return

	var coin = coin_scene.instantiate()
	add_child(coin)
	
	var viewport = get_tree().root.get_viewport()
	var viewport_size = viewport.get_visible_rect().size
	coin.position = Vector2(
		rng.randf_range(100, viewport_size.x - 100),
		-50
	)
	coin.scale = Vector2(0.5, 0.5)

func toggle_spawning(state: bool):
	can_spawn = state
