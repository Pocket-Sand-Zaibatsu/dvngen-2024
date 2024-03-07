extends Area2D
class_name Projectile

var uuid: String

@onready var velocity: Vector2i

func set_velocity(new_velocity: Vector2i) -> void:
	velocity = new_velocity

func spawn(spawn_grid: Vector2i) -> void:
	position = LevelGrid.grid_to_position(spawn_grid + velocity)

func despawn() -> void:
	get_parent().projectiles.erase(uuid)
	self.queue_free()

func _on_body_entered(body: Variant):
	body.change_health(-10000)
	despawn()

func _on_input_received(_action: String) -> void:
	var next_grid = LevelGrid.position_to_grid(position) + velocity
	if LevelGrid.CELL_TYPE.OBSTACLE == LevelGrid.get_cell(next_grid):
		despawn()
	else:
		position = LevelGrid.grid_to_position(next_grid)
	
