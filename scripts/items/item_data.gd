# -- Base class for all items
class_name ItemData
extends Resource

var id: String = ""
var display_name: String = ""

# -- Small Icon
var icon: Texture2D
# -- Big Icon (falls back to Icon if null)
var hud_texture: Texture2D
# -- How fast fuel goes down when item is selected
var drain_multiplier: float = 1.0
# -- spawned with item
var held_scene: PackedScene

func get_hud_texture() -> Texture2D:
	return hud_texture if hud_texture else icon
