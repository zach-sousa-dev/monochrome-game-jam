extends CharacterBody2D


# Set these in the inspector!
@export_category("Movement Control")
@export var horizontal_max_velocity: float = 300.0
@export var horizontal_acceleration: float = 10.0
@export var horizontal_decceleration: float = 10.0
@export var jump_velocity: float = -400.0

@export_category("Cheats")
@export var coyote_time_duration_seconds: float = 1
var has_jumped: bool = false
var has_started_timer: bool = false

@export_category("Camera")
@export var using_follow_camera: bool = true
@export var cam_path: NodePath
@export var cam_speed: float = 1

@export_category("Debug")
@export var debug_mode: bool = false
@export var debug_coyote: bool = false
@export var debug_velocity: bool = false

# References
@onready var animated_sprite: AnimatedSprite2D = $"AnimatedSprite2D"
@onready var coyote_timer: Timer = $"CoyoteTimer"
@onready var camera: Camera2D = self.get_node(cam_path)



func _ready() -> void:
	coyote_timer.timeout.connect(coyote_timer.stop)  # Apparently timers don't stop when they reach zero automatically (they just restart) so this makes it do that



func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		# Starts coyote time
		if coyote_timer.is_stopped() and not has_jumped and not has_started_timer:
			coyote_timer.start(coyote_time_duration_seconds)
			has_started_timer = true
			print("started timer")
	else: 
		# Reset the coyote timer
		has_jumped = false
		has_started_timer = false
		coyote_timer.stop()

	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote_timer.time_left > 0):
		velocity.y = jump_velocity
		coyote_timer.stop()
		has_jumped = true	# You can only use coyote time once per jump

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if direction:
		# Accelerate toward the maximum running speed
		velocity.x = move_toward(velocity.x, horizontal_max_velocity * direction, horizontal_acceleration * delta)
		# Instantly snap to maxiumum running speed
		#velocity.x = horizontal_max_velocity * direction
	else:
		# Decelerate toward no speed if on the ground
		if is_on_floor(): velocity.x = move_toward(velocity.x, 0, horizontal_decceleration * delta)
		
	# Animation controls
	_choose_animation(is_on_floor(), velocity.x, direction, animated_sprite)
	
	# Follow cam
	if using_follow_camera: camera.global_position = camera.global_position.lerp(self.position, cam_speed)
	
	# Debug
	if debug_mode:
		_print_debug()
		
	# Execute movement
	move_and_slide()



# controls which animation should be playing
func _choose_animation(grounded: bool, horizontal_speed: float, direction: float, animated_sprite: AnimatedSprite2D) -> void:
	# Flipping
	if (direction < 0 && grounded): animated_sprite.flip_h = true
	elif (direction > 0 && grounded): animated_sprite.flip_h = false
	
	# State controller
	if not grounded: animated_sprite.play("fall")
	elif horizontal_speed != 0: animated_sprite.play("run")
	else: animated_sprite.play("stand")



# this is just used for debug purposes
func _print_debug() -> void:
	const format_string := "%-10s%4.2f"

	if debug_coyote and !coyote_timer.is_stopped():
			print("\n")
			print(format_string % ["coyote time max:", coyote_timer.wait_time])
			print(format_string % ["coyote timer stopped:", float(coyote_timer.is_stopped())])
			print(format_string % ["coyote time left:", coyote_timer.time_left])
	
	if debug_velocity and !velocity == Vector2.ZERO:
		print("\n")
		print(format_string % ["h_vel:", velocity.x])
		print(format_string % ["y_vel:", velocity.y])
