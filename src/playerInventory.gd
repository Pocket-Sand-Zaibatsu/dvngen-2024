extends Node

const SlotClass =  preload("res://interfaces/inventory/InvSlot.gd")
const ItemClass = preload("res://scenes/Items/items/items.gd")
const NUM_INVENTORY_SLOTS = 20

signal inventory_updated
signal atk_bonus_chaged


enum EquipSlots {
	HEAD,
	NECK,
	BODY,
	ARMS,
	LEGS,
	FEET,
	RHAND,
	LHAND,
}

var inventory = {}

var equips = {}

func reset():
	inventory.clear()
	equips.clear()

func add_item(item_name, item_quantity):
	for item in inventory:
		if inventory[item][0] == item_name:
			var stack_size = int(JsonItemData.item_data[item_name]["StackSize"])
			var able_to_add = stack_size - inventory[item][1]
			if able_to_add >= item_quantity:
				inventory[item][1] += item_quantity
				inventory_updated.emit()
				return
			else:
				inventory[item][1] -= able_to_add
				item_quantity = item_quantity - able_to_add
	#Item doesn't exist in inventory yet, so add it to an empty slot.
	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [item_name, item_quantity]
			inventory_updated.emit()
			return

func remove_item(slot: SlotClass):
	match slot.slot_type:
		SlotClass.SlotType.INVENTORY:
			inventory.erase(slot.slot_index)
		_:
			equips.erase(slot.slot_index)



func add_item_to_empty_slot(item: ItemClass, slot: SlotClass):
	match slot.slot_type:
		SlotClass.SlotType.INVENTORY:
			inventory[slot.slot_index] = [item.item_name, item.item_quantity]
		_:
			equips[slot.slot_index] = [item.item_name, item.item_quantity]




func add_item_quantity(slot: SlotClass, quantity_to_add: int):
	match slot.slot_type:
		SlotClass.SlotType.INVENTORY:
			inventory[slot.slot_index][1] += quantity_to_add
		_:
			equips[slot.slot_index][1] += quantity_to_add


func decrease_item_quantity(slot: SlotClass, quantity_to_remove: int):
	match slot.slot_type:
		SlotClass.SlotType.INVENTORY:
			inventory[slot.slot_index][1] -= quantity_to_remove
		_:
			equips[slot.slot_index][1] -= quantity_to_remove


func get_item_in_slot(equip_slot: EquipSlots):
	var possible_item = equips.get(equip_slot, [])
	if 0 < possible_item.size():
		var item = Item.new()
		item.set_item_data(possible_item[Item.ItemComponents.NAME], possible_item[Item.ItemComponents.QUANTITY])
		return item
	return null

func get_all_equipped_items() -> Array[Item]:
	var equipped: Array[Item] = []
	for slot_key in EquipSlots.keys():
		var possible_item = get_item_in_slot(EquipSlots[slot_key])
		if possible_item:
			equipped.push_back(possible_item)
	return equipped

func get_equipped_stat(stat_name: String) -> int:
	var stat = 0
	for item in get_all_equipped_items():
		stat += item[stat_name]
	return stat

func get_equipped_armor_class() -> int:
	return get_equipped_stat("armor_class")

func get_equipped_attack_bonus() -> int:
	return get_equipped_stat("attack_bonus")

	

