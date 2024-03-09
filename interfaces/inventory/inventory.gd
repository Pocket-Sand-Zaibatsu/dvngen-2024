extends Node2D

@onready var slots = $TextureRect/InvGrid.get_children()
@onready var equip_slots = $TextureRect/EquipGrid.get_children()
var holding_item = null


func _ready():
	for i in range(slots.size()):
		slots[i].gui_input.connect(slot_gui_input.bind(slots[i]))
		slots[i].slot_index = i
	equip_slots[0].slot_type = Slot.SlotType.HEAD
	equip_slots[1].slot_type = Slot.SlotType.NECK
	equip_slots[2].slot_type = Slot.SlotType.BODY
	equip_slots[3].slot_type = Slot.SlotType.ARMS
	equip_slots[4].slot_type = Slot.SlotType.LEGS
	equip_slots[5].slot_type = Slot.SlotType.FEET
	equip_slots[6].slot_type = Slot.SlotType.HAND
	equip_slots[7].slot_type = Slot.SlotType.HAND
	for i in range(equip_slots.size()):
		equip_slots[i].gui_input.connect(slot_gui_input.bind(equip_slots[i]))
		equip_slots[i].slot_index = i
		equip_slots[i].allowed_types = [equip_slots[i].slot_type]
	_on_inventory_update()
	PlayerInventory.inventory_updated.connect(_on_inventory_update)

func _on_inventory_update() -> void:
	initialize_inventory()
	initialize_equips()

func initialize_inventory():
	for i in range(slots.size()):
		if PlayerInventory.inventory.has(i):
			slots[i].initialize_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1])

func initialize_equips():
	for i in range(equip_slots.size()):
		if PlayerInventory.equips.has(i):
			equip_slots[i].initialize_item(PlayerInventory.equips[i][0], PlayerInventory.equips[i][1])

func slot_gui_input(event: InputEvent, slot: Slot):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT && event.pressed:
			use_item(slot)
		else:
			if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
				if holding_item != null:
					if !slot.item:
						left_click_empty_slot(slot)
					else: 
						if holding_item.item_name != slot.item.item_name:
							left_click_different_item(event, slot)
						else:
							left_click_same_item(slot)
				elif slot.item:
						left_click_not_holding(slot)
			_on_inventory_update()



func use_item(slot: Slot):
	var item_cat = str(JsonItemData.item_data[slot.item.item_name]["ItemCategory"])
	var quantity = PlayerInventory.inventory.get(slot.slot_index, ["", 0])[1]
	if item_cat == "Consumable" && quantity >= 1:
		Player.change_health(+ 10)
		PlayerInventory.decrease_item_quantity(slot, 1)
		quantity = PlayerInventory.inventory.get(slot.slot_index, ["", 0])[1]
		if quantity < 1:
			PlayerInventory.remove_item(slot)
			slot.removeFromSlot()



func _input(_event):
	if holding_item:
		holding_item.global_position = get_global_mouse_position()

func left_click_empty_slot(slot: Slot):
	if item_category_to_slot_type(holding_item.category) in slot.allowed_types:
		PlayerInventory.add_item_to_empty_slot(holding_item, slot)
		slot.putIntoSlot(holding_item)
		holding_item = null


func left_click_different_item(event: InputEvent, slot: Slot):
	if item_category_to_slot_type(holding_item.category) in slot.allowed_types:
		PlayerInventory.remove_item(slot)
		PlayerInventory.add_item_to_empty_slot(holding_item, slot)
		var temp_item = slot.item
		slot.pickFromSlot()
		temp_item.global_position = event.global_position
		slot.putIntoSlot(holding_item)
		holding_item = temp_item

func left_click_same_item(slot: Slot):
	var stack_size = int(JsonItemData.item_data[slot.item.item_name]["StackSize"])
	var able_to_add = stack_size - slot.item.item_quantity
	if able_to_add >= holding_item.item_quantity:
		PlayerInventory.add_item_quantity(slot, holding_item.item_quantity)
		slot.item.add_item_quantity(holding_item.item_quantity)
		holding_item.queue_free()
		holding_item = null
	else:
		PlayerInventory.add_item_quantity(slot, able_to_add)
		slot.item.add_item_quantity(able_to_add)
		holding_item.decrease_item_quantity(able_to_add)
		

func left_click_not_holding(slot: Slot):
	PlayerInventory.remove_item(slot)
	holding_item = slot.item
	slot.pickFromSlot()
	holding_item.global_position = get_global_mouse_position()
	

	

func item_category_to_slot_type(category: String) -> Slot.SlotType:
	match category:
		"Sword","Bow","Staff":
			return Slot.SlotType.HAND
		"Helmet":
			return Slot.SlotType.HEAD
		"Cape", "Necklace":
			return Slot.SlotType.NECK
		"Chest":
			return Slot.SlotType.BODY
		"Gloves":
			return Slot.SlotType.ARMS
		"Pants":
			return Slot.SlotType.LEGS
		"Boots":
			return Slot.SlotType.FEET
		_:
			return Slot.SlotType.INVENTORY
