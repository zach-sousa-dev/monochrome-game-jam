class_name Spawner
extends Node2D

@export var delay: float = 5
@export var enemy_scene: PackedScene
@export var max_enemies: int
var enemies: Array[fly_guy]
@onready var timer: Timer = $Timer
@export var offset: Vector2

func _ready() -> void:
	timer.wait_time = delay
	timer.start()
	timer.connect("timeout", spawn_enemy)
	self.call_deferred("spawn_enemy")

func _process(delta: float) -> void:
	for enemy in enemies:
		if enemy._dead:
			enemies.erase(enemy)

func spawn_enemy() -> void:
	if enemies.size() >= max_enemies: return
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
	enemy.home = enemy.home + Vector2(randf_range(-offset.x, offset.x), randf_range(-offset.y, offset.y)) 
	#enemy.reparent(get_tree().current_scene)
	
	enemies.append(enemy)
	
