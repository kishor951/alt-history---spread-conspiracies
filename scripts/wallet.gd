extends Node

var money: int = 1000

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func add_money(amount: int):
	money += amount
	
func remove_money(amount: int) -> bool:
	if money >= amount:
		money -= amount
		return true
	return false

func get_money() -> int:
	return money
