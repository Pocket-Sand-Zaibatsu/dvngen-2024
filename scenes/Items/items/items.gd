extends Node2D

var item_name
var item_quantity
var category: String

func _ready():
	var rand_val = randi() % 3
	if rand_val == 0:
		item_name  = "td_items_coins_gold"
	elif rand_val == 1:
		item_name = "td_items_potion_red"
	else:
		item_name = "td_items_weapon_sword"
	$TextureRect.texture = load("res://assets/sprites/items/" + item_name + ".png")
	var stack_size = int(JsonItemData.item_data[item_name]["StackSize"])
	item_quantity =  randi() % stack_size + 1
	
	if stack_size == 1:
		$QuantityLabel.visible = false
	else:
		$QuantityLabel.text = str(item_quantity)
		
	category = JsonItemData.item_data[item_name]["ItemCategory"]

func set_item (nm, qt):
	item_name = nm
	item_quantity = qt
	$TextureRect.texture = load("res://assets/sprites/items/" + item_name + ".png")
	
	var stack_size = int(JsonItemData.item_data[item_name]["StackSize"])
	if stack_size ==1:
		$QuantityLabel.visible = false
	else:
		$QuantityLabel.visible = true
		$QuantityLabel.text = str(item_quantity)


func add_item_quantity(amount_to_add):
	item_quantity += amount_to_add
	$QuantityLabel.text = str(item_quantity)
	
func decrease_item_quantity(amount_to_remove):
	item_quantity -= amount_to_remove
	$QuantityLabel.text = str(item_quantity)
	
func _to_string() -> String:
	return "Item: %s\n    category: %s\n    quantity: %s" % [item_name, category, item_quantity]
