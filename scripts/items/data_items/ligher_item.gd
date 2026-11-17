class_name LighterItem
extends ItemData


func _init():
	id = "lighter"
	display_name = "Lighter"
	icon = preload("res://assets/ui_assets/placeholder/small-weapons/lighter.png")
	hud_texture = icon # CHANGE LATER TO ASSET (big verison) -----
	drain_multiplier = 5
	
	# -- tool
	weapon_frames = preload("res://assets/animations/weapons/hold_lighter.tres")
	shooting_pos = Vector2.ZERO
	light_brightness = 1.2
	light_range = 4.0
	light_color = Color(1.0, 1.0, 1.0)
	
	#-- fireball screen
	var ligher_flame: PackedScene = load("res://scenes/projectiles_scenes/LighterBlast.tscn")
	projectiles = [
		# -- (scene, speed, damage, angle, lifetime)
		ProjectileData.make(ligher_flame, 100, 5.0, 0.0, 10.0)
	]
	
	fire_cooldown = 0.3
	fuel_per_shot = 3.0
