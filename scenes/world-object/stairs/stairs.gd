extends WorldObject
class_name Stairs

signal generate_level

var biome_texture = {
	LevelGenerator.DungeonBiome.STONE: "res://assets/sprites/world/td_world_wall_stone_stair_down.png",
	LevelGenerator.DungeonBiome.CAVE: "res://assets/sprites/world/td_world_wall_cave_stair_down.png",
	LevelGenerator.DungeonBiome.CRYPT: "res://assets/sprites/world/td_world_wall_crypt_stair_up.png",
	LevelGenerator.DungeonBiome.SEWER: "res://assets/sprites/world/td_world_wall_sewer_stair_down.png",
}

func spawn_with_biome(biome: LevelGenerator.DungeonBiome, spawn_grid: Vector2i):
	$Sprite2D.texture = load(biome_texture.get(biome, LevelGenerator.DungeonBiome.STONE))
	spawn(spawn_grid)

func _on_body_entered(body: Variant):
	if is_body_player(body):
		generate_level.emit()
