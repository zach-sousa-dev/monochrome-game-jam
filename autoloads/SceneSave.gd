extends Node

var previous_scene_path: String = ""


func switch_scene(target_path: String) -> void:
	previous_scene_path = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file(target_path)
	KeyInventory.keys.clear()

func go_back() -> void:
	if not previous_scene_path.is_empty():
		var current_path = get_tree().current_scene.scene_file_path
		get_tree().change_scene_to_file(previous_scene_path)
		previous_scene_path = current_path
		KeyInventory.keys.clear()
