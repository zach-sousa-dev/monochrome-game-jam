class_name squichable_guy
extends CharacterBody2D

@export_category("Stats")
@export var health: float = 30.0
@export var contact_damage: float = 10.0
@export var damage_cooldown: float = 1.0
@export var fuel_reward: float = 15.0

@export_category("Movement")
@export var patrol_speed: float = 40.0
@export var chase_speed: float = 50.0
@export var chase_range: float = 80.0
@export var gravity: float = 900.0
@export var lose_sight_time: float = 0.5
@export var giv_up_time: float = 1.0
@export var ignore_time: float = 2.0

@export_category("Stomp")
@export var stomp_damage: float = 10.0
@export var stomp_bounce: float = 250.0
@export var stomp_margin: float = 4.0

@export var alert_distance: float = 16.0

@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var hit_box: Area2D = %HitBox
@onready var floor_check: RayCast2D = %RayCast2D
@onready var alert: AnimatedSprite2D = %Alert
@onready var death = %Death
@onready var death_sound: AudioStreamPlayer2D  = %DeathSound
@onready var hit_sound: AudioStreamPlayer2D  = %HitSound
@onready var alert_sound: AudioStreamPlayer2D = %AlertSound

var dir: int = 1
var player: Node2D = null
var _dead: bool = false
var _damage_timer: float = 0.0
var _was_seeing: bool = false
var _lose_sight_timer: float = 0.0
var _stuck_timer: float = 0.0
var _ignore_timer: float = 0.0
var _attcking: bool = false


func _ready():
	add_to_group("enemy")
	player = get_tree().get_first_node_in_group("player")
	if player:
		add_collision_exception_with(player)
	
	animated_sprite_2d.animation_finished.connect(_on_animation_finished)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	_damage_timer = maxf(_damage_timer - delta, 0.0)
	_ignore_timer = maxf(_ignore_timer - delta, 0.0)
	
	if _can_see_player():
		_lose_sight_timer = lose_sight_time
	else:
		_lose_sight_timer = maxf(_lose_sight_timer - delta, 0.0)
	
	var chasing: bool = _lose_sight_timer > 0.0
	
	if chasing and not _was_seeing:
		_show_alert()
	
	_was_seeing = chasing
	
	if chasing:
		_chase()
		alert.play()
	else:
		alert.stop()
		alert.frame = 0
		_patrol()
	
	animated_sprite_2d.flip_h = dir > 0
	_update_animation(chasing)
	
	_aim_alert()
	move_and_slide()
	_check_contact_damage()

func _update_animation(chasing: bool):
	if _attcking:
		return
	
	if chasing and absf(velocity.x) > 1.0:
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("run")
		animated_sprite_2d.stop()
		animated_sprite_2d.frame = 0

func _attck():
	_attcking = true
	animated_sprite_2d.play("attack")

func _on_animation_finished():
	if animated_sprite_2d.animation == "attack":
		_attcking = false

func _can_see_player() -> bool:
	if _ignore_timer > 0.0:
		return false
	
	if player == null or not is_instance_valid(player):
		return false
	
	if global_position.distance_to(player.global_position) > chase_range:
		return false
	
	return _has_line_of_sight()

func _has_line_of_sight() -> bool:
	var space := get_world_2d().direct_space_state
	var query := PhysicsRayQueryParameters2D.create(global_position, player.global_position, 1)
	query.exclude = [get_rid()]
	var hit := space.intersect_ray(query)
	return hit.is_empty()

func _patrol():
	if is_on_wall() or (is_on_floor() and not floor_check.is_colliding()):
		dir *= -1
		_update_floor_check()
	velocity.x = dir * patrol_speed
	

func _chase():
	var diff: float = player.global_position.x - global_position.x
	if absf(diff) > 4.0:
		dir = 1 if diff > 0 else -1
	
	_update_floor_check()
	
	if is_on_floor() and not floor_check.is_colliding():
		velocity.x = 0.0
		_stuck_timer += get_physics_process_delta_time()
		if _stuck_timer >= giv_up_time:
			_stuck_timer = 0.0
			_ignore_timer = ignore_time
			_lose_sight_timer = 0.0
			dir *= -1
			_update_floor_check()
	else:
		_stuck_timer = 0.0
		velocity.x = dir * chase_speed


func _update_floor_check():
	floor_check.position.x = absf(floor_check.position.x) * dir
	floor_check.force_raycast_update()


func _check_contact_damage():
	if _dead:
		return
	
	for body in hit_box.get_overlapping_bodies():
		if not body.is_in_group("player"):
			continue
		
		if _is_stomp(body):
			_stomp(body)
		elif _damage_timer <= 0.0:
			body.hurt(contact_damage, global_position)
			_damage_timer = damage_cooldown
			_attck()
		return

func _is_stomp(body: Node2D) -> bool:
	if not body is CharacterBody2D:
		return false
	
	var falling: bool = body.velocity.y > 0.0
	var above: bool = body.global_position.y < global_position.y - stomp_margin
	return falling and above

func _stomp(body: CharacterBody2D):
	take_damage(stomp_damage)
	body.velocity.y = -stomp_bounce
	_damage_timer = 0.3

func take_damage(amount: float):
	if _dead:
		return
	health -= amount
	_flash()
	hit_sound.play()
	if health <= 0.0:
		_die()

func _flash():
	var tween := create_tween()
	for i in 2:
		tween.tween_property(animated_sprite_2d, "modulate", Color.BLACK, 0.15)
		tween.tween_property(animated_sprite_2d, "modulate", Color.WHITE, 0.15)

func _aim_alert():
	if not alert.visible or player == null:
		return
	
	var a_dir: Vector2 = (player.global_position - global_position).normalized()
	alert.position = a_dir * alert_distance
	alert.rotation = a_dir.angle() + PI

func _show_alert():
	alert.visible = true
	alert.play("spot")
	alert_sound.play()
	_aim_alert()

func _die():
	_dead = true
	set_physics_process(false)
	hit_box.monitoring = false
	
	Fuel.refuel(fuel_reward)
	
	death_sound.reparent(get_tree().current_scene)
	death_sound.play()
	death_sound.finished.connect(death_sound.queue_free)
	
	death.reparent(get_tree().current_scene)
	death.emitting = true
	get_tree().create_timer(1.2).timeout.connect(death.queue_free)
	
	
	var tween := create_tween()
	tween.tween_property(animated_sprite_2d, "modulate:a", 0.0, 0.4)
	tween.tween_callback(queue_free)
