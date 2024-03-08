extends WorldObject
class_name ItemDrop

var item_name
var player = null
var being_picked_up

func _ready():
	item_name = "td_items_potion_red"

func _on_body_entered(_body):
	PlayerInventory.add_item(item_name, 1)
	despawn()

#func pick_up_item(body):
	#player = body
	#being_picked_up = true
