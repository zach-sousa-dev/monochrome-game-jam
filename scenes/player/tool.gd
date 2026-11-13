# -- the tool in the players hand
class_name Tool
extends Node2D


signal projectile_changed(data: ProjectileData)

# -- node vars
@export var body_sprite_path: NodePath = ^"../AnimatedSprite2D"

@onready var tool_point_light_2d: PointLight2D = %ToolPointLight2D
@onready var tool_sprite_2d: AnimatedSprite2D = %ToolSprite2D
@onready var tool_marker_2d: Marker2D = %ToolMarker2D
@onready var body_sprite: AnimatedSprite2D =  get_node(body_sprite_path)

# -- currently held item
var item: ItemData = null
# -- cooldown on tool
var _cooldown: float = 0.0

# for some reason the sprite is offset by 1 pixel when flipped to the left
# so I'm just manually adjusting for that and need to store the original position. 
# This is a bad solution but it works for now.
@onready var tool_sprite_2d_original_position: Vector2 = tool_sprite_2d.position

func _ready():
	PlayerInventory.selected_changed.connect(_on_selected_tool_changed)
	Fuel.fuel_changed.connect(_on_fuel_changed)
	body_sprite.animation_changed.connect(_sync_to_body)
	body_sprite.frame_changed.connect(_sync_to_body)
	_on_selected_tool_changed(PlayerInventory.get_selected())


func _process(delta):
	_cooldown = maxf(_cooldown - delta, 0.0)
	_update_filp()

# -- LOADING ITEM DATA -------

# -- new item is picked, loads its data onto tool
func _on_selected_tool_changed(new_item: ItemData):
	item = new_item
	
	if item == null:
		tool_sprite_2d.visible = false
		
		return
	
	tool_sprite_2d.visible = item.weapon_frames != null
	tool_sprite_2d.sprite_frames = item.weapon_frames
	tool_point_light_2d.enabled = item.light_brightness > 0.0
	tool_point_light_2d.color = item.light_color
	tool_point_light_2d.texture_scale = item.light_range
	
	_update_light()
	_update_filp()
	_sync_to_body()

# -- ANIMATIONS -------

# -- coppies the playe current animation + frame onto the tool
func _sync_to_body():
	if tool_sprite_2d.sprite_frames == null:
		return
	
	var anime: StringName = body_sprite.animation
	if not tool_sprite_2d.sprite_frames.has_animation(anime):
		return
	
	if tool_sprite_2d.animation != anime:
		tool_sprite_2d.animation = anime
	
	tool_sprite_2d.frame = body_sprite.frame

# -- copies players flip and mirroirs the marker
func _update_filp():
	# by mirroring the scale we can flip the local position of the light, marker, and sprite
	# (local position inside of tool)
	self.scale = Vector2(get_facing(), 1)
	# then we can flip the position of the whole tool to the other side of the player
	position.x = (abs(position.x) * get_facing())
	
	# old code
	#tool_sprite_2d.flip_h = body_sprite.flip_h
	#if item:
	#	tool_marker_2d.position = Vector2(item.shooting_pos.x * get_facing(), item.shooting_pos.y)

# -- 1 = facing right, -1 = facing left (from player sprite)
func get_facing() -> int:
	return -1 if body_sprite.flip_h else 1

# -- fuel changed = update brightness
func _on_fuel_changed(_ratio: float):
	_update_light()


# -- LIGHTS -------

# -- sets light brightness (dims with fuel)
func _update_light():
	if item == null:
		return
	
	var ratio = Fuel.get_fuel_ratio()
	var brightness: float = item.light_brightness
	var size: float = item.light_range
	if item.dim_with_fuel:
		brightness *= lerp(0.2, 1.0, ratio)
		size *= lerp(0.4, 1.0, ratio)
	
	tool_point_light_2d.energy = brightness
	tool_point_light_2d.texture_scale = size

# -- SHOOTING  -------

# -- gets curretly selected projectile
func get_current_projectile() -> ProjectileData:
	if item == null or item.projectiles.is_empty():
		return null
	item.projectile_index = clampi(item.projectile_index, 0, item.projectiles.size() -1)
	return item.projectiles[item.projectile_index]

# -- swithces to next(1) or last(-1) projectile, wraps
func cycle_projectile(dir: int):
	if item == null or item.projectiles.size() <= 1:
		return
	
	item.projectile_index = wrapi(item.projectile_index + dir, 0, item.projectiles.size())
	projectile_changed.emit(get_current_projectile())
 
# -- true if the held item can shoot RIGHT NOW
func can_shoot() -> bool:
	return item != null and not item.projectiles.is_empty() and _cooldown <= 0.0 and not Fuel.is_dead



# -- fires the selected projectile from the marker
func shoot():
	if not can_shoot():
		return
	
	var data: ProjectileData = get_current_projectile()
	if data.scene == null:
		return
	
	_cooldown = item.fire_cooldown
	Fuel.take_damage(item.fuel_per_shot)
	
	var facing: int = get_facing()
	var projectile: Node2D = data.scene.instantiate()
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = tool_marker_2d.global_position
	
	var dir: Vector2 = Vector2(facing, 0).rotated(deg_to_rad(-data.angle) * facing)
	if projectile.has_method("launch"):
		projectile.launch(dir, data)
