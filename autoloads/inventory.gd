class_name Inventory
extends Node

# -- item was added or removed
signal items_changed
# -- a differnt item was picked
signal selected_changed(item: ItemData)

# -- how many items the player can carry
@export var max_slots = 3

# -- all player items
var items: Array[ItemData] = []
# -- which slot is picked
var selected_index: int = -1

# -- next / previous item
func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("item_next"):
		cycle(1)
	elif event.is_action_pressed("item_prev"):
		cycle(-1)

# -- adds an item if there is room picks if nothing is picked yet
func add_item(item: ItemData) -> bool:
	if item == null or items.size() >= max_slots:
		return false
	items.append(item)
	items_changed.emit()
	if selected_index == -1:
		select(items.size() -1)
	return true

# -- picks the item in a slot
func select(index: int, force: bool = false):
	if index < 0 or index > items.size():
		return
	if index == selected_index and not force:
		return
	
	selected_index = index
	selected_changed.emit(get_selected())

# -- moves to the next or previous item, wraps around
func cycle(dir: int):
	if items.is_empty():
		return
	select(wrapi(selected_index + dir, 0, items.size()))

# -- the picked item (or null if none)
func get_selected():
	if selected_index < 0 or selected_index >= items.size():
		return null
	
	return items[selected_index]

# -- removes all items and refills fuel
func clear():
	items.clear()
	selected_index = -1
	items_changed.emit()
	selected_changed.emit(null)
	Fuel.reset_fuel()
