extends Area2D

@export var bounce_force: float = 400.0
@onready var chity_spring = %ChitySpring


func _ready():
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D):
	if not body.is_in_group("player"):
		return
	
	body.velocity.y = -bounce_force
	
	var tween = create_tween()
	tween.tween_property(chity_spring, "scale", Vector2(0.4, 0.2), 0.05)
	tween.tween_property(chity_spring, "scale", Vector2(0.3, 0.6), 0.1)
	tween.tween_property(chity_spring, "scale", Vector2(0.4, 0.4), 0.15)
