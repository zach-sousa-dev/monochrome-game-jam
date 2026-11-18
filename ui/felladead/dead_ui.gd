extends CanvasLayer


@onready var respawn: Button = %Respawn
@onready var home: Button  = %Home
@onready var fade_rect = %FadeRect


func _ready():
	fade_rect.color.a = 0.0
	respawn.pressed.connect(_on_respawn_pressed)
	home.pressed.connect(_on_home_pressed)


func _on_respawn_pressed():
	await _catch_this_fade(1.0, 0.2).finished
	Fuel.reset_fuel()
	SceneSave.go_back()

func _on_home_pressed():
	await _catch_this_fade(1.0, 0.2).finished
	get_tree().change_scene_to_file("res://scenes/Screens/MainMenu.tscn")

func _catch_this_fade(target_alpha: float, dur: float = 1.0):
	var tween = create_tween()
	tween.tween_property(fade_rect, "color:a", target_alpha, dur)
	return tween 
