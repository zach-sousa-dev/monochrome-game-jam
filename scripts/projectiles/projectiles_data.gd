class_name ProjectileData
extends Node

# -- bullet scene
var scene: PackedScene
var speed: float = 300.0
var damage: float = 10.0
var lifetime: float = 2.0
# -- degress up (+) or down (-) from stright ahdead
var angle: float = 2.0


# -- makes a new Projectile scene
# -- (scene, speed, damage, angle, lifetime)
# -- ex: ProjectileData.make(fireball, 250.0, 15.0, 0.0, 1)
static func make(p_scene: PackedScene, p_speed: float, p_damage: float, p_angle: float, p_lifetime: float) -> ProjectileData:
	var data := ProjectileData.new()
	data.scene = p_scene
	data.speed = p_speed
	data.damage = p_damage
	data.lifetime = p_lifetime
	data.angle = p_angle
	return data
