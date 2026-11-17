class_name Fade
extends Sprite2D

var fade: bool = false
signal faded

func _process(delta: float) -> void:
	if fade:
		modulate.a = move_toward(modulate.a, 1, 0.005)
	if modulate.a == 1:
		faded.emit()
