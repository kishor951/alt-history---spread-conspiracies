extends Node

var music_player: AudioStreamPlayer

func _ready():
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	
	# Load your music file
	var music = load("res://assets/sounds/conspiracy-theory-255714 (1).mp3")
	music_player.stream = music
	
	# Configure the player
	music_player.bus = "Master"
	music_player.volume_db = -10
	music_player.stream.loop = true
	
	# Start playing
	music_player.play()

func stop_music():
	music_player.stop()

func start_music():
	music_player.play()

func set_volume(volume: float):
	music_player.volume_db = volume
