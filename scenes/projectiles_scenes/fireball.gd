# -- A Fireball
extends Area2D

# -- default pixels per second (overridden by ProjectileData)
var speed: float = 300.0
# -- default damage (overridden by ProjectileData)
var damage: float = 10.0
# -- default seconds alive (overridden by ProjectileData)
var lifetime: float = 2.0
# -- direction x speed (set by launch)
var _velocity: Vector2 = Vector2.ZERO

# -- listen for hitting bodies (enemies, walls, floor)
func _ready():
	body_entered.connect(_on_body_entered)

# -- called by Tool.shoot(), direction + this projectiles settings
func launch(direction: Vector2, data: ProjectileData = null):
	if data:
		speed = data.speed
		damage = data.damage
		lifetime = data.lifetime
	_velocity = direction.normalized() * speed
	rotation = direction.angle()

# -- disappears when time runs out
func _physics_process(delta: float):
	position += _velocity * delta
	lifetime -= delta
	if lifetime <= 0.0:
		queue_free()

# -- hit something, damage enemies, ignore the player, disappear
func _on_body_entered(body: Node):
	if body.is_in_group("player"):
		return
	if body.is_in_group("enemy") and body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
