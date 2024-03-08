extends Node2D

var item_name
var item_quantity
var category: String


func set_item (nm, qt):
	item_name = nm
	item_quantity = qt
	$TextureRect.texture = load("res://assets/sprites/items/" + item_name + ".png")
	category = JsonItemData.item_data[item_name]["ItemCategory"]
	
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
