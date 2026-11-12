class_name DialogBox
extends Control

static var dialog_box_scene: PackedScene = load("res://scenes/npc/dialog-box.tscn")

@onready var name_label = $CanvasLayer/NamePanel/MarginContainer/NameLabel
@onready var dialog_label = $CanvasLayer/DialogPanel/MarginContainer/DialogLabel
@onready var voice_player = $"AudioStreamPlayer2D"

@export var dialog_name: String
@export var dialog_text: String
@export var letters_per_second: float = 0.1
@export var voice_sound: AudioStream

var elapsed_time_since_last_letter: float = 0

func _ready() -> void:
	name_label.text = dialog_name
	dialog_label.text = dialog_text
	dialog_label.visible_characters = 0
	voice_player.stream = voice_sound
	
func _process(delta: float) -> void:
	elapsed_time_since_last_letter += delta
	if elapsed_time_since_last_letter < letters_per_second: return
	
	elapsed_time_since_last_letter = 0
	
	if dialog_label.visible_characters < dialog_label.get_total_character_count():
		dialog_label.visible_characters += 1
		voice_player.pitch_scale = randf_range(0.85, 1.0)
		if has_letters(dialog_label.text[dialog_label.visible_characters - 1]): voice_player.play()

# Factory/constructor function
static func construct_dialog(dialog_name: String, dialog_text: String, letters_per_second: float, voice_sound: AudioStream) -> DialogBox:
	var new_dialog_box: DialogBox = dialog_box_scene.instantiate()
	new_dialog_box.dialog_name = dialog_name
	new_dialog_box.dialog_text = dialog_text
	new_dialog_box.letters_per_second = letters_per_second
	new_dialog_box.voice_sound = voice_sound
	return new_dialog_box

func has_letters(string: String):
	var regex = RegEx.new()
	regex.compile("[a-zA-Z]+")
	if regex.search(str(string)):
		return true
	else:
		return false
