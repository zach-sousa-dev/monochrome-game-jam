class_name LanternItem
extends ItemData


func _init():
	id = "lantern"
	display_name = "Lantern"
	icon = preload("res://assets/ui_assets/laturnExample.png")
	hud_texture = icon # CHANGE LATER TO ASSET (big verison)  -----
	drain_multiplier = 2
	held_scene = null
