extends "res://scenes/doors/door.gd"

@export var scene: PackedScene

func do_enter() -> void:
	get_tree().change_scene_to_packed(scene)
