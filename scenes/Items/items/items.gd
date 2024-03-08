extends Node2D
class_name Item

enum DamageArray {
	COUNT = 0,
	SIDES = 1,
	BONUS = 2,
}

enum ItemComponents {
	NAME = 0,
	QUANTITY = 1,
}

var item_data
var item_name
var item_quantity
var category: String
var projectile_type: String
var damage: DicePool

func set_item_data(new_name: String, new_quantity: int):
	item_name = new_name
	item_data = JsonItemData.item_data[item_name]
	item_quantity = new_quantity
	category = item_data["ItemCategory"]
	if "projectile_type" in item_data.keys() && "damage" in item_data.keys():
		projectile_type = item_data["projectile_type"]
		damage = DicePool.new(
			[
				Dice.new(
					item_data["damage"][DamageArray.SIDES],
					item_data["damage"][DamageArray.COUNT]
				)
			],
			item_data["damage"][DamageArray.BONUS]
		)


func set_item (nm, qt):
	set_item_data(nm, qt)
	$TextureRect.texture = load("res://assets/sprites/items/" + item_name + ".png")
	var stack_size = int(item_data["StackSize"])
	if stack_size == 1:
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
