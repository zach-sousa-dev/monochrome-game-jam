extends Node2D

@export_category("Door Config")
@export var player: Player
@export var destination: Marker2D
@export var locked: bool

func _ready() -> void:
	add_to_group("doors")
