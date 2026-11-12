# -- Base class for all items
class_name ItemData
extends Resource

# -- BASIC --------
var id: String = ""
var display_name: String = ""
# -- Small Icon
var icon: Texture2D
# -- Big Icon (falls back to Icon if null)
var hud_texture: Texture2D
# -- How fast fuel goes down when item is selected
var drain_multiplier: float = 1.0

# -- TOOLS --------
# -- tool animations
var weapon_frames: SpriteFrames
# -- where bullets come out (faceing right)
var shooting_pos: Vector2 = Vector2.ZERO


# -- LIGHT --------
var light_brightness: float = 0.0
var light_range: float = 2.4
var light_color: Color = Color(1.0,1.0,1.0)
var dim_with_fuel: bool = true

# -- SHOOTING --------
# -- fired every shot
var projectiles: Array[ProjectileData] = []
# -- which projectile is seleced
var projectile_index: int = 0
var fire_cooldown: float = 0.3
# -- fuel lost per shot
var fuel_per_shot: float = 0.0

func get_hud_texture() -> Texture2D:
	return hud_texture if hud_texture else icon
