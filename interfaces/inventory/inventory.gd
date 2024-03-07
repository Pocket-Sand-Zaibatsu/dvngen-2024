extends Node2D

const SlotClass =  preload("res://interfaces/inventory/InvSlot.gd")
@onready var inventory_slots = $TextureRect/InvGrid.get_children()
@onready var equip_slots = $TextureRect/EquipGrid.get_children()
var holding_item = null


func _ready():
	var slots = inventory_slots
	
	for i in range(slots.size()):
		slots[i].gui_input.connect(slot_gui_input.bind(slots[i]))
		slots[i].slot_index = i
		slots[i].SlotType = SlotClass.SlotType.INVENTORY
	
	for i in range(equip_slots.size()):
		equip_slots[i].gui_input.connect(slot_gui_input.bind(equip_slots[i]))
		equip_slots[i].slot_index = i
		equip_slots[0].slotType = SlotClass.SlotType.HEAD
		equip_slots[1].slotType = SlotClass.SlotType.NECK
		equip_slots[2].slotType = SlotClass.SlotType.BODY
		equip_slots[3].slotType = SlotClass.SlotType.ARMS
		equip_slots[4].slotType = SlotClass.SlotType.LEGS
		equip_slots[5].slotType = SlotClass.SlotType.FEET
		equip_slots[6].slotType = SlotClass.SlotType.RHAND
		equip_slots[7].slotType = SlotClass.SlotType.LHAND
	
	initialize_inventory()
	initialize_equips()


func initialize_inventory():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		if PlayerInventory.inventory.has(i):
			slots[i].initialize_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i])

func initialize_equips():
	for i in range(equip_slots.size()):
		if PlayerInventory.equips.has(i):
			equip_slots[i].initialize_item(PlayerInventory.equips[i][0], PlayerInventory.equips[i])

func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
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

func _input(_event):
	if holding_item:
		holding_item.global_position = get_global_mouse_position()


func left_click_empty_slot(slot: SlotClass):
	PlayerInventory.add_item_to_empty_slot(holding_item, slot)
	slot.putIntoSlot(holding_item)
	holding_item = null
	

func left_click_different_item(event: InputEvent, slot: SlotClass):
	PlayerInventory.remove_item(slot)
	PlayerInventory.add_item_to_empty_slot(holding_item, slot)
	var temp_item = slot.item
	slot.pickFromSlot()
	temp_item.global_position = event.global_position
	slot.putIntoSlot(holding_item)
	holding_item = temp_item


func left_click_same_item(slot: SlotClass):
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
		

func left_click_not_holding(slot: SlotClass):
	PlayerInventory.remove_item(slot)
	holding_item = slot.item
	slot.pickFromSlot()
	holding_item.global_position = get_global_mouse_position()
