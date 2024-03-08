#!/usr/bin/env python3

from collections import OrderedDict
from glob import glob
from json import dumps
from os.path import basename, join

items = OrderedDict()

item_paths = [basename(item_path).removesuffix('.png') for item_path in glob(
    join('..', 'assets', 'sprites', 'items', '*.png'))]
item_paths.sort()
for item_file in item_paths:
    new_item = dict()
    new_item['ItemCategory'] = ''
    new_item['StackSize'] = 1
    new_item['Description'] = ''
    if 'weapon' in item_file:
        new_item['ItemCategory'] = 'Sword'
        new_item['projectile_type'] = 'slash'
        new_item['damage'] = [1, 6, 0]
    for item_type in ['flask', 'herb', 'potion']:
        if item_type in item_file:
            new_item['ItemCategory'] = 'Consumable'
            new_item['AddHealth'] = 10
            new_item['StackSize'] = 99
            break
    for item_type in ['amulet', 'boot', 'cape', 'chest', 'glove', 'hat', 'helm', 'pant', 'shield']:
        if item_type in item_file:
            new_item['ItemCategory'] = item_type.title()
            new_item['armor_class'] = 1
            break
    items[item_file] = new_item

print(dumps(items, indent=2))
