extends CharacterBody2D


@export_category("Items")
@export var starting_items: Array[ItemDB.Id] = [ItemDB.Id.LIGHTER]

@export_category("Fuel")
@export var test_speed: float = 30.0
@export var auto_drain: bool = false

@onready var tool = $Tool
@onready var animated_sprite_2d = $AnimatedSprite2D


func _ready() -> void:
	
	animated_sprite_2d.flip_h = true
	
	add_to_group("player") # so projectile knows its the player
	
	if PlayerInventory.items.is_empty():
		for item_id in starting_items:
			PlayerInventory.add_item(ItemDB.create(item_id))
	
