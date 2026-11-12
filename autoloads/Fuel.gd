class_name FuelSystem
extends Node

# -- fuel went up or down (sends 0.0 to 1.0
signal fuel_changed(ratio: float)
# -- fuel hit 0
signal died

# -- full tank
@export var max_fuel: float = 100.0
# -- fuel lost  every second
@export var drain_per_second: float = 0.2

# -- curent fuel 
var fuel: float = 0.0
var is_dead: bool = false
var draining: bool = false

# -- starts with full dank
func _ready():
	fuel = max_fuel

# -- drains fuel every frame while draining is on
func _process(delta):
	if draining and not is_dead:
		change_fuel(-get_drain_rate() * delta)

# -- remove fuel
func take_damage(amount: float):
	if amount > 0.0:
		change_fuel(-amount)

# -- adds fuel
func refuel(amount: float):
	if amount > 0.0:
		change_fuel(amount)

# -- sets back to full
func reset_fuel():
	fuel = max_fuel
	is_dead = false
	fuel_changed.emit(get_fuel_ratio())

# -- add or removes fuel, kills player at 0
func change_fuel(amount: float):
	if is_dead:
		return
	fuel = clampf(fuel + amount, 0.0, max_fuel)
	fuel_changed.emit(get_fuel_ratio())
	if fuel <= 0.0:
		is_dead = true
		died.emit()

# -- fuel as 0.0 to 1.0
func get_fuel_ratio():
	return fuel / max_fuel if max_fuel > 0.0 else 0.0

# -- gets drain  rate from item
func get_drain_rate():
	var item: ItemData = PlayerInventory.get_selected()     #Player is holding
	var multiplier: float = 1.0                             #Default speed if no item is held
	if item:                                                #Only if an item is selected             
		multiplier = item.drain_multiplier                  #Use items speed
	return drain_per_second * multiplier                    #Base drain x item speed = fuel lost per second
