extends Button

@export var texture: Texture
@export var audio: AudioStreamWAV
@onready var hud = preload("res://interfaces/hud/hud.tscn")
@onready var audio_stream_player: AudioStreamPlayer = get_node("ClassButtonAudio")
@onready var dungeon_scene = preload("res://scenes/dungeon.tscn")

func _ready():
	icon = texture
	text = name
	audio_stream_player.stream = audio

func _on_pressed():
	Player.player_class = name
	var lower_class = Player.player_class.to_lower()
	Player.animated_sprite.sprite_frames.remove_animation("Down")
	Player.animated_sprite.sprite_frames.add_animation("Down")
	Player.animated_sprite.sprite_frames.add_frame("Down", load("res://assets/sprites/heroes/{class}/td_monsters_{class}_d1.png".format({"class": lower_class})))
	Player.animated_sprite.sprite_frames.add_frame("Down", load("res://assets/sprites/heroes/{class}/td_monsters_{class}_d2.png".format({"class": lower_class})))
	Player.animated_sprite.sprite_frames.remove_animation("Up")
	Player.animated_sprite.sprite_frames.add_animation("Up")
	Player.animated_sprite.sprite_frames.add_frame("Up", load("res://assets/sprites/heroes/{class}/td_monsters_{class}_u1.png".format({"class": lower_class})))
	Player.animated_sprite.sprite_frames.add_frame("Up", load("res://assets/sprites/heroes/{class}/td_monsters_{class}_u2.png".format({"class": lower_class})))
	Player.animated_sprite.sprite_frames.remove_animation("Left")
	Player.animated_sprite.sprite_frames.add_animation("Left")
	Player.animated_sprite.sprite_frames.add_frame("Left", load("res://assets/sprites/heroes/{class}/td_monsters_{class}_l1.png".format({"class": lower_class})))
	Player.animated_sprite.sprite_frames.add_frame("Left", load("res://assets/sprites/heroes/{class}/td_monsters_{class}_l2.png".format({"class": lower_class})))
	Player.animated_sprite.sprite_frames.remove_animation("Right")
	Player.animated_sprite.sprite_frames.add_animation("Right")
	Player.animated_sprite.sprite_frames.add_frame("Right", load("res://assets/sprites/heroes/{class}/td_monsters_{class}_r1.png".format({"class": lower_class})))
	Player.animated_sprite.sprite_frames.add_frame("Right", load("res://assets/sprites/heroes/{class}/td_monsters_{class}_r2.png".format({"class": lower_class})))

	audio_stream_player.play()
	await get_tree().create_timer(1.0).timeout
	SceneChanger.change_scene(SceneChanger.PossibleScene.DUNGEON)
