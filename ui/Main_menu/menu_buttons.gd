extends CanvasLayer


@onready var play: Button = %Play
@onready var credits: Button  = %Credits
@onready var fade_rect = %FadeRect


func _ready():
	fade_rect.color.a = 0.0
	credits.pressed.connect(_on_credits_pressed)
	play.pressed.connect(_on_play_pressed)


func _on_credits_pressed():
	await _catch_this_fade(1.0, 0.2).finished
	get_tree().change_scene_to_file("res://scenes/Screens/Credits.tscn")

func _on_play_pressed():
	await _catch_this_fade(1.0, 0.2).finished
	get_tree().change_scene_to_file("res://scenes/level/level.tscn")

func _catch_this_fade(target_alpha: float, dur: float = 1.0):
	var tween = create_tween()
	tween.tween_property(fade_rect, "color:a", target_alpha, dur)
	return tween 
