extends Node2D

@onready var opening_dialog: NPC = $"../OpeningDialog"
@onready var closing_dialog: NPC = $"../ClosingDialog"
@onready var closing_dialog_collider: CollisionShape2D = $"../ClosingDialog/CollisionShape2D"
@onready var music: AudioStreamPlayer2D = $"../Music"
@onready var boss: Boss = $"../Boss"
@onready var darkness: CanvasModulate = $"../Darkness"
@onready var player: Player = $"../Player"
@onready var fade: Fade = $"../FadeToWhite" 

var title_screen: PackedScene = preload("res://scenes/zach-scene.tscn")

func _ready() -> void:
	opening_dialog.connect("dialog_complete", on_completed_opening_dialog)
	closing_dialog.connect("dialog_complete", fade_out)
	fade.connect("faded", change_scene)
	
func _process(delta: float) -> void:
	if boss:
		if boss._dead:
			closing_dialog_collider.disabled = false
			music.stop()
			darkness.visible = false
			player.auto_drain = false
	
	
func on_completed_opening_dialog() -> void:
	music.play()
	opening_dialog.queue_free()
	
func fade_out() -> void:
	get_tree().paused = true
	fade.fade = true
	
func change_scene() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(title_screen)
