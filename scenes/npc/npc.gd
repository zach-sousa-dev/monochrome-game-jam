# You shouldn't have to change any code in this script.
# All options and dialog can be configured and writted in the inspector.
# If you want to change the look of the NPC, in the Scene panel,
# right click on the NPC node and enable editable children.
# Note: If you want an event to occur after the conversation, you can connect
# to the NPC's dialog_complete signal.


extends Node2D

@export_category("Config")
@export var player_group: String

@export_category("Dialog Options")
@export var speeches: Array[Speech]

var touching_player: bool = false
var current_speech_index: int = 0
var current_dialog_box: DialogBox
signal dialog_complete

func _ready() -> void:
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") && touching_player:
	 	# pause time for everything but this, this node's process mode is set to always, so it will ignore this and keep running
		get_tree().paused = true
		
		if current_dialog_box: current_dialog_box.queue_free() # remove old dialog
		
		if current_speech_index > speeches.size() - 1: 
			# end dialog
			current_speech_index = 0 
			get_tree().paused = false
			dialog_complete.emit()
			#print("dialog complete")
			return
		
		# construct new dialog box
		current_dialog_box = DialogBox.construct_dialog(speeches[current_speech_index].person.person_name, speeches[current_speech_index].dialog, speeches[current_speech_index].person.seconds_per_letter, speeches[current_speech_index].person.person_voice if !speeches[current_speech_index].is_muted else null)
		add_child(current_dialog_box)
		current_speech_index += 1 # go to next dialog



func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group(player_group): return
	touching_player = true



func _on_body_exited(body: Node2D) -> void:
	if not body.is_in_group(player_group): return
	touching_player = false
