# -- Every Item in the game
class_name ItemDB
extends  RefCounted

# -- Add items here
enum Id {
	LIGHTER,
	LANTERN,
	FLAMETHROWER
}


# -- function that let you create new item (ex: ItemDB.Id.LIGHTER)
static func create(item_id: Id) -> ItemData:
	#case switch
	match  item_id:
		Id.LIGHTER:
			return LighterItem.new()
		Id.LANTERN:
			return LanternItem.new()
		Id.FLAMETHROWER:
			return FlameThrower.new()
	# -- if not item with that name is real
	push_error("ItemDB: unknown item")
	return null
