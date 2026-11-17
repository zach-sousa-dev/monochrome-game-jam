extends Node2D

@export_category("Door Config")
@export var player: Player
@export var destination: Marker2D
@export var locked: bool
@export var door_id: int

@onready var npc: NPC = $NPC
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

const warp_sound: AudioStream = preload("res://assets/sounds/doors/warp.wav")
const unlock_sound: AudioStream = preload("res://assets/sounds/doors/unlock.wav")
const locked_sound: AudioStream = preload("res://assets/sounds/doors/locked.wav")

func _ready() -> void:
	add_to_group("doors")
	npc.connect("dialog_complete", try_enter)
	if locked:
		anim.play("locked")
	else:
		anim.play("unlocked")

func try_enter() -> void:
	if not locked:
		do_enter()
	elif locked and KeyInventory.has_key_with_id(door_id):
		audio_player.stream = unlock_sound
		audio_player.play()
		locked = false
		KeyInventory.remove_key_with_id(door_id)
		anim.play("unlocked")
	else: 
		audio_player.stream = locked_sound
		audio_player.play()
		
func do_enter() -> void:
	player.global_position = destination.global_position
	audio_player.stream = warp_sound
	audio_player.play()
