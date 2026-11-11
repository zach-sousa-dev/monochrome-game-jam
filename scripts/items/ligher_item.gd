class_name LighterItem
extends ItemData


func _init():
	id = "lighter"
	display_name = "Lighter"
	icon = preload("res://assets/ui_assets/Lighter.png")
	hud_texture = icon # CHANGE LATER TO ASSET (big verison) -----
	drain_multiplier = 5
	held_scene = null
