extends CharacterBody2D

@export var lit: bool

@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D


@onready var light = $PointLight2D


const light_sound: AudioStream = preload("res://assets/sounds/doors/warp.wav")

#signal grant_key

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("enemy")
	if(lit):
		anim.play("lit")
	else:
		anim.play("unlit")
	light.enabled = lit


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func take_damage(amount: float):
	if lit:
		return
	lit = true
	audio_player.stream = light_sound
	audio_player.play()
	anim.play("lit")
	light.enabled = true
	#emit_signal("grant_key")
	
