extends Node

const NUM_INVENTORY_SLOTS = 20

var inventory = {
	0: ["td_items_potion_red", 1]  #--> slot_index: [item_name, item_quantity]
}

func add_item(item_name, item_quantity):
	for item in inventory:
		if inventory[item][0] == item_name:
			#Chek if slot is full
			inventory[item][1] += item_quantity
			return
	#Item doesn't exist in inventory yet, so add it to an empty slot.
	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [item_name, item_quantity]
			return
