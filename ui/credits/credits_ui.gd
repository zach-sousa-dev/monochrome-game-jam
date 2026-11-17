extends CanvasLayer

@onready var back: Button = %Back
@onready var fade_rect = %FadeRect


func _ready():
	fade_rect.color.a = 0.0
	back.pressed.connect(_on_back_pressed)

func _on_back_pressed():
	await _catch_this_fade(1.0, 0.2).finished
	get_tree().change_scene_to_file("res://scenes/Screens/MainMenu.tscn")

func _catch_this_fade(target_alpha: float, dur: float = 1.0):
	var tween = create_tween()
	tween.tween_property(fade_rect, "color:a", target_alpha, dur)
	return tween 
