# KeyInventory keeps a record of what keys the player has

class_name KeyInventory
extends Node

static var keys: Array[Key]

# add a key to the list if it doesn't already exist
static func add_key(key: Key) -> void:
	if not has_key_with_id(key.key_id):
		keys.append(key)

# check if key is in keys
static func has_key_with_id(id: int) -> bool:
	return not find_key(id, keys)

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
