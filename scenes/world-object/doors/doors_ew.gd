@icon("res://assets/sprites/world/td_world_door_stone_h_closed.png")
extends WorldObject
class_name EwDoor

signal player_entered

var biome_texture = {
	LevelGenerator.DungeonBiome.STONE: "stone",
	LevelGenerator.DungeonBiome.CAVE: "wood",
	LevelGenerator.DungeonBiome.CRYPT: "evil",
	LevelGenerator.DungeonBiome.SEWER: "gate"
}
var biome: LevelGenerator.DungeonBiome

func set_biome(new_biome: LevelGenerator.DungeonBiome) -> void:
	biome = new_biome

func _ready() -> void:
	super()
	sprite.texture = load("res://assets/sprites/world/td_world_door_%s_h_closed.png" % biome_texture.get(biome, "stone"))

func _on_body_entered(body: Variant):
	sprite.texture = load("res://assets/sprites/world/td_world_door_%s_h_open.png" % biome_texture.get(biome, "stone"))
	if is_body_player(body):
		player_entered.emit()

func _on_body_exited(_body: Variant):
	sprite.texture = load("res://assets/sprites/world/td_world_door_%s_h_closed.png" % biome_texture.get(biome, "stone"))
