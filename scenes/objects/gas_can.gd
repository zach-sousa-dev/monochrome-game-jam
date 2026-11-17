extends Area2D

@export var fuel_amount: float = 20.0
@onready var death: CPUParticles2D = %Death
@onready var break_sound: AudioStreamPlayer2D = %break_sound
@onready var gascan: Sprite2D = $Gascan

var _is_collected: bool = false

func _ready():
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D):
	if _is_collected or not body.is_in_group("player"):
		return
	
	if Fuel.is_full():
		return
	
	_is_collected = true
	Fuel.refuel(fuel_amount)
	
	break_sound.reparent(get_tree().current_scene)
	break_sound.play()
	break_sound.finished.connect(break_sound.queue_free)
	
	death.reparent(get_tree().current_scene)
	death.emitting = true
	get_tree().create_timer(1.2).timeout.connect(death.queue_free)
	
	queue_free()
