extends AnimatableBody2D

@export var positions: Array[Marker2D]
@export var duration: float
var current_position: int = 0

var tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_moving()

func start_moving() -> void:
	tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops().set_parallel(false)
	
	for marker in positions:
		tween.tween_property(self, "global_position", marker.global_position, duration / positions.size())
