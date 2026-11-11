extends Node2D


@export var player_group: String
@export var label_text: String
@export var scene_node: NodePath

@onready var label: Label = $Control/Label

func _ready() -> void:
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)
	label.text = label_text
	label.visible = false

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group(player_group): return
	label.visible = true
	print("entered")
	label.reparent(get_node(scene_node))
	
func _on_body_exited(body: Node2D) -> void:
	if not body.is_in_group(player_group): return
	label.visible = false
	label.reparent(self)
