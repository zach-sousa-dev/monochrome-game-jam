extends Node2D

@export var starting_items: Array[ItemDB.Id] = [ItemDB.Id.LIGHTER, ItemDB.Id.LANTERN]
@export var test_speed: float = 30.0
@export var auto_drain: bool = true


func _ready() -> void:
	
	if PlayerInventory.items.is_empty():
		for item_id in starting_items:
			PlayerInventory.add_item(ItemDB.create(item_id))
	
	Fuel.draining = auto_drain
	Fuel.died.connect(_on_died)



func _process(delta: float) -> void:
	
	if Input.is_physical_key_pressed(KEY_Q):
		print("q pressed")
		Fuel.take_damage( Fuel.get_drain_rate() * test_speed * delta)
		
	if Input.is_physical_key_pressed(KEY_R):
		Fuel.refuel(test_speed * delta)


func _on_died() -> void:
	print("Died - refilling fuel")
	Fuel.reset_fuel()
