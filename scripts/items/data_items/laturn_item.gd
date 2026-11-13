class_name LanternItem
extends ItemData


func _init():
	id = "lantern"
	display_name = "Lantern"
	icon = preload("res://assets/ui_assets/placeholder/small-weapons/lantern_no_particle.png")
	hud_texture = icon # CHANGE LATER TO ASSET (big verison)  -----
	drain_multiplier = 2
	
	# -- tool
	weapon_frames = preload("res://assets/animations/weapons/hold_lantern.tres")
	shooting_pos = Vector2.ZERO
	light_brightness = 1.2
	light_range = 4.0
	light_color = Color(1.0, 0.8, 0.5)
	
	#-- fireball screen
	var fireball: PackedScene = load("res://scenes/projectiles_scenes/lazer.tscn")
	#-- projectiles stored by lighter
	projectiles = [
		# -- (scene, speed, damage, angle, lifetime)
		ProjectileData.make(fireball, 250.0, 15.0, 5.0, 1)
	]
	
	fire_cooldown = 0.5
	fuel_per_shot = 3.0
