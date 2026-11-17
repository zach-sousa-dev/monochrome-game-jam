extends Button

@onready var hover_sound = $"../AudioStreamPlayer2D"


func _ready():
	pivot_offset = size / 2
	mouse_entered.connect(_grow)
	mouse_exited.connect(_shrink)


func _grow():
	create_tween().tween_property(self, "scale", Vector2(1.1, 1.1), 0.1)
	
	if hover_sound:
		hover_sound.play()

func _shrink():
	create_tween().tween_property(self, "scale", Vector2.ONE, 0.1)
