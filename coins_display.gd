extends Node2D

var coins = 50  # Starting coins

@onready var coins_label = $CoinsLabel

func _ready():
	add_to_group("wallet")  # Add this line to join the wallet group
	update_display()

func update_display():
	coins_label.text = str(coins)

func add_coins(amount):
	coins += amount
	update_display()

func spend_coins(amount):
	if coins >= amount:
		coins -= amount
		update_display()
		return true
	else:
		print("❌ Not enough coins!")
		return false
