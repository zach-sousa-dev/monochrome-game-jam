# You shouldn't have to change any code in this script.
# All options and dialog can be configured and writted in the inspector.
# If you want to change the look of the NPC, in the Scene panel,
# right click on the NPC node and enable editable children.
# Note: If you want an event to occur after the conversation, you can connect
# to the NPC's dialog_complete signal.


extends Node2D

@export_category("Config")
@export var player_group: String
@export var interact_label_text: String
@export var scene_node: NodePath

@export_category("Dialog Options")
@export var seconds_per_letter: float = 0.1
@export var voice_sound: AudioStream
@export var speeches: Array[Speech]

#@onready var label: RichTextLabel = $CanvasLayer/InteractLabel
#@onready var canvas_layer: CanvasLayer = $CanvasLayer

var touching_player: bool = false
var current_speech_index: int = 0
var current_dialog_box: DialogBox
signal dialog_complete

func _ready() -> void:
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)
	#label.text = interact_label_text
	#canvas_layer.visible = false



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
		current_dialog_box = DialogBox.construct_dialog(speeches[current_speech_index].name, speeches[current_speech_index].dialog, seconds_per_letter, voice_sound)
		add_child(current_dialog_box)
		current_speech_index += 1 # go to next dialog



func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group(player_group): return
	#canvas_layer.visible = true
	touching_player = true
	#canvas_layer.reparent(get_node(scene_node))



func _on_body_exited(body: Node2D) -> void:
	if not body.is_in_group(player_group): return
	#canvas_layer.visible = false
	touching_player = false
	#canvas_layer.reparent(self)
