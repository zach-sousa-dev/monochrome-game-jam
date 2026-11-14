# KeyDistributor is responsible for instantiating a new key and
# adding it to the KeyInventory.

extends Node2D

var key_scene: PackedScene = preload("res://scenes/doors/key.tscn")

@export var key_owner: KeySignalEmitter
@export var key_id: int
@export var player: Player

func _ready() -> void:
	key_owner.connect("grant_key", grant_key)

func grant_key() -> void:
	var new_key: Key = Key.create_key(key_id, player)
	KeyInventory.add_key(new_key)
	add_child(new_key)
