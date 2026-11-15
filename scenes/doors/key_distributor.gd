# KeyDistributor is responsible for instantiating a new key and
# adding it to the KeyInventory.

extends Node2D

var key_scene: PackedScene = preload("res://scenes/doors/key.tscn")

@export var key_owner: KeySignalEmitter
@export var key_id: int
@export var player: Player

var has_given_key: bool = false

func _ready() -> void:
	key_owner.connect("grant_key", grant_key)

func grant_key() -> void:
	if not has_given_key:
		var new_key: Key = Key.create_key(key_id, player)
		
		var successful: bool = KeyInventory.add_key(new_key)
		if not successful: new_key.queue_free() # remove key as it has already been given
		
		add_child(new_key)
		new_key.reparent(get_tree().current_scene)
		has_given_key = true
