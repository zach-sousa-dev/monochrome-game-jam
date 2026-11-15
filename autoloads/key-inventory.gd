# KeyInventory keeps a record of what keys the player has

class_name KeyInventory
extends Node

static var keys: Array[Key]

# add a key to the list if it doesn't already exist, returns false if it already exists
static func add_key(key: Key) -> bool:
	if not has_key_with_id(key.key_id):
		keys.append(key)
		return true
	return false
	
static func get_keys() -> Array[Key]:
	return keys

# check if key is in keys
static func has_key_with_id(id: int) -> bool:
	return not (find_key(id, keys) == null)

# remove the key from keys
static func remove_key_with_id(id: int) -> void:
	var found_key: Key = find_key(id, keys)
	keys.erase(found_key)
	found_key.queue_free()

static func find_key(id: int, keys: Array[Key]) -> Key:
	for key in keys:
		if key.key_id == id:
			return key
	return null
