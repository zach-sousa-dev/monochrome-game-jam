# Key is the actual key itself.

class_name Key
extends Node2D

var key_id: int
var player: Player
@export var travel_speed: float = 1
static var key_scene: PackedScene = load("res://scenes/doors/key.tscn")


func _process(delta: float) -> void:
	var goal_position = Vector2(player.position.x + 30 if player.is_left_facing() else player.position.x - 30, player.position.y)
	
	self.global_position = self.global_position.lerp(goal_position, travel_speed)

# creates a new key based on the params
static func create_key(key_id: int, player: Player) -> Key:
	var new_key: Key = key_scene.instantiate()
	new_key.key_id = key_id
	new_key.player = player
	return new_key
