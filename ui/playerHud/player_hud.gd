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

# -- the slot copeies in the hotbar
var _slots: Array[Control] = []


# -- sets up the sharder, listens to inventory and fuel
func _ready():
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
	fuel_bar_container.visible = tex != null
	fuel_texture.texture = tex

# -- sens the fuel amount
func _set_progress(ratio: float):
	var mat := fuel_texture.material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("progress", ratio)
