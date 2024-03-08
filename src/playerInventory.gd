extends Node

const SlotClass =  preload("res://interfaces/inventory/InvSlot.gd")
const ItemClass = preload("res://scenes/Items/items/items.gd")
const NUM_INVENTORY_SLOTS = 20

var inventory = {
}

var equips ={
	0: ["td_items_weapon_sword", 1],
	1: ["td_items_leather_helm", 1],
	2: ["td_items_leather_pant", 1],
	3: ["td_items_leather_boot", 1],
}

func add_item(item_name, item_quantity):
	for item in inventory:
		if inventory[item][0] == item_name:
			var stack_size = int(JsonItemData.item_data[item_name]["StackSize"])
			var able_to_add = stack_size - inventory[item][1]
			if able_to_add >= item_quantity:
				inventory[item][1] += item_quantity
				return
			else:
				inventory[item][1] +- able_to_add
				item_quantity = item_quantity - able_to_add

	#Item doesn't exist in inventory yet, so add it to an empty slot.
	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [item_name, item_quantity]
			return

func remove_item(slot: SlotClass):
	match slot.SlotType:
		SlotClass.SlotType.INVENTORY:
			inventory.erase(slot.slot_index)
		_:
			equips.erase(slot.slot_index)

func add_item_to_empty_slot(item: ItemClass, slot: SlotClass):
	match slot.SlotType:
		SlotClass.SlotType.INVENTORY:
			inventory[slot.slot_index] = [item.item_name, item.item_quantity]
		_:
			equips[slot.slot_index] = [item.item_name, item.item_quantity]
	
	
func add_item_quantity(slot: SlotClass, quantity_to_add: int):
	match slot.SlotType:
		SlotClass.SlotType.INVENTORY:
			inventory[slot.slot_index][1] += quantity_to_add
		_:
			equips[slot.slot_index][1] += quantity_to_add
	
	
