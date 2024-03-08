extends Panel
class_name Slot

var default_texture = preload("res://assets/sprites/inventory/item_slot_default.png")
var empty_texture = preload("res://assets/sprites/inventory/item_slot_empty.png")

var default_style: StyleBoxTexture = null
var empty_style: StyleBoxTexture = null

var ItemClass = preload("res://scenes/Items/items/items.tscn")
var item = null
var slot_index
var allowed_types = [
	SlotType.INVENTORY,
	SlotType.HEAD,
	SlotType.NECK,
	SlotType.BODY,
	SlotType.ARMS,
	SlotType.LEGS,
	SlotType.FEET,
	SlotType.HAND,
]

enum SlotType{
	INVENTORY,
	HEAD,
	NECK,
	BODY,
	ARMS,
	LEGS,
	FEET,
	HAND,
}

@onready var slot_type: SlotType = SlotType.INVENTORY



func _ready():
	default_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	default_style.texture = default_texture
	empty_style.texture = empty_texture
	refresh_style()
		
func refresh_style():
	if item == null:
		set('theme_override_styles/panel', empty_style)
	else:
		set('theme_override_styles/panel', default_style)
		
		
func pickFromSlot():
	remove_child(item)
	var inventoryNode = find_parent("Inventory")
	inventoryNode.add_child(item)
	item = null
	refresh_style()
	
func putIntoSlot(new_item):
	item = new_item
	item.position = Vector2(0,0)
	var inventoryNode = find_parent("Inventory")
	inventoryNode.remove_child(item)
	add_child(item)
	refresh_style()

func initialize_item(item_name, item_quantity):
	if item == null:
		item = ItemClass.instantiate()
		add_child(item)
		item.set_item(item_name, item_quantity)
	else:
		item.set_item(item_name, item_quantity)
	refresh_style()
	

