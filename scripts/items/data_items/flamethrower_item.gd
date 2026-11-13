class_name FlameThrower
extends ItemData


func _init():
	id = "flamethrower"
	display_name = "FlameThrower"
	icon = preload("res://assets/ui_assets/placeholder/small-weapons/flamethrower.png")
	hud_texture = icon # CHANGE LATER TO ASSET (big verison) -----
	drain_multiplier = 5
	
	# -- tool
	weapon_frames = preload("res://assets/animations/weapons/hold_flamethrower.tres")
	shooting_pos = Vector2.ZERO
	light_brightness = 1.2
	light_range = 4.0
	light_color = Color(1.0, 1.0, 1.0)
	
	#-- fireball screen
	var fireball: PackedScene = load("res://scenes/projectiles_scenes/fireball.tscn")
	var lazer: PackedScene = load("res://scenes/projectiles_scenes/lazer.tscn")
	#-- projectiles stored by flamethrower
	projectiles = [
		# -- (scene, speed, damage, angle, lifetime)
		ProjectileData.make(fireball, 250.0, 15.0, 0.0, 10),
	]
	
	fire_cooldown = 0.5
	fuel_per_shot = 3.0
