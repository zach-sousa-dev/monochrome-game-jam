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
var _exploded: bool = false

@onready var explosion: CPUParticles2D = %Explosion
@onready var explosion_sound = $Explosion_sound
@onready var shooting_sound = %Shooting_sound


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
	
	shooting_sound.play()

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
	_explode()

func _explode():
	if _exploded:
		return
	
	_exploded = true
	
	explosion.reparent(get_tree().current_scene)
	explosion.emitting = true
	get_tree().create_timer(explosion.lifetime + 0.2).timeout.connect(explosion.queue_free)
	
	explosion_sound.reparent(get_tree().current_scene)                   # NEW: keep playing after fireball is gone
	explosion_sound.play()                                               # NEW
	explosion_sound.finished.connect(explosion_sound.queue_free)         # NEW: clean up when done
	
	if shooting_sound.playing:                                           # NEW: don't cut off the shoot sound
		shooting_sound.reparent(get_tree().current_scene)
		shooting_sound.finished.connect(shooting_sound.queue_free)
	
	queue_free()
