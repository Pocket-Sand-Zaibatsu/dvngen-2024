extends WorldObject
class_name ItemDrop

var item_name: String = "td_items_coins_gold"
var player = null
var being_picked_up

func _ready():
	$Sprite2D.texture = load("res://assets/sprites/items/" + item_name + ".png")

func set_item_name(new_item_name: String) -> void:
	item_name = new_item_name

func _on_body_entered(body):
	if is_body_player(body):
		GameLogTransport._on_log_messaged("Player picks up %s" % item_name.trim_prefix("td_items_"))
		PlayerInventory.add_item(item_name, 1)
		despawn()

#func pick_up_item(body):
	#player = body
	#being_picked_up = true
