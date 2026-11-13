extends CanvasLayer

# -- Fuel shader
const FUEL_FILL = preload("uid://c1pblfgw3u4bw")

# -- default (if blank)
@export var default_texture: Texture2D
@export var selected: Color = Color(1, 1, 1, 1)
@export var unselected: Color = Color(1, 1, 1, 0.45)

# -- autoloads
@onready var inventory: Inventory = PlayerInventory
@onready var fuel: FuelSystem = Fuel

# -- HUD vars
@onready var items_bar_container = %ItemsBarContainer
@onready var slot_template = %ItemPanel
@onready var fuel_bar_container = %FualBarContainer
@onready var fuel_texture = %ItemTexture

# -- Tween vars
@onready var bar_home_pos: Vector2 = fuel_bar_container.position
var bar_tween: Tween
var can_amimate := false

# -- the slot copeies in the hotbar
var _slots: Array[Control] = []


# -- sets up the sharder, listens to inventory and fuel
func _ready():
	await get_tree().process_frame
	
	slot_template.visible = false
	
	var mat := ShaderMaterial.new()
	mat.shader = FUEL_FILL
	fuel_texture.material = mat
	
	inventory.items_changed.connect(_rebuild_slots)
	inventory.selected_changed.connect(_on_selected_changed)
	fuel.fuel_changed.connect(_set_progress)
	
	_rebuild_slots()
	_on_selected_changed(inventory.get_selected())
	_set_progress(fuel.get_fuel_ratio())
	
	can_amimate = true

# -- removes old slots and makes new ones items
func _rebuild_slots():
	
	for slot in _slots:
		slot.queue_free()
	_slots.clear()
	
	for i in inventory.items.size():
		var item: ItemData = inventory.items[i]
		var slot: Control = slot_template.duplicate() as Control
		slot.visible = true
		items_bar_container.add_child(slot)
		slot.get_node("ItemNumber").text = str(i+1)
		slot.get_node("TextureRect").texture = item.icon
		var button := slot.get_node("ItemButton") as BaseButton
		button.focus_mode = Control.FOCUS_NONE
		button.pressed.connect(inventory.select.bind(i))
		_slots.append(slot)
	

# -- swaps the big image to selected item
func _on_selected_changed(item: ItemData):
	var tex : Texture2D = default_texture
	
	if item: 
		tex = item.get_hud_texture()
	
	if bar_tween:
		bar_tween.kill()
	
	if not can_amimate:
		fuel_texture.texture = tex
		fuel_bar_container.visible = tex != null
		return
	
	bar_tween = get_tree().create_tween()
	bar_tween.tween_property(fuel_bar_container, "position", bar_home_pos + Vector2(0, 200), 0.1)
	bar_tween.tween_callback(func():
		fuel_texture.texture = tex
		fuel_bar_container.visible = tex != null
	)
	
	bar_tween.tween_interval(0.1)
	if tex != null:
		bar_tween.tween_property(fuel_bar_container, "position", bar_home_pos, 0.1)

# -- sens the fuel amount
func _set_progress(ratio: float):
	var mat := fuel_texture.material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("progress", ratio)
