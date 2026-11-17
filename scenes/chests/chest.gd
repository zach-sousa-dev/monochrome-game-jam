extends Node2D

@export_category("Chest Config")
@export var player: Player
@export var locked: bool
@export var chest_id: int
@export var item: ItemDB.Id = ItemDB.Id.FLAMETHROWER

@onready var npc: NPC = $NPC
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

const unlock_sound: AudioStream = preload("res://assets/sounds/chests/unlock.wav")
const locked_sound: AudioStream = preload("res://assets/sounds/chests/locked.wav")

var opened : bool = false

func _ready() -> void:
	add_to_group("chests")
	npc.connect("dialog_complete", try_open)
	if locked:
		anim.play("locked")
	else:
		anim.play("unlocked")

func try_open() -> void:
	if opened:
		return
		
	if locked and KeyInventory.has_key_with_id(chest_id):
		KeyInventory.remove_key_with_id(chest_id)
		locked = false
		
	if not locked:
		audio_player.stream = unlock_sound
		audio_player.play()
		anim.play("open")
		opened = true
		PlayerInventory.add_item(ItemDB.create(item))
	else: 
		audio_player.stream = locked_sound
		audio_player.play()
