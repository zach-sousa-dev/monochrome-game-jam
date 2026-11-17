@tool
extends VBoxContainer

var feed: CameraFeed

func _ready() -> void:
	await get_tree().process_frame
	await get_tree().process_frame

	if not get_parent().gui:
		return

	get_parent().get_node("main").visible = false
	
	CameraServer.monitoring_feeds = true
	
	var feeds = CameraServer.feeds()
	
	if feeds.is_empty():
		GDTUtils.printerr_stack("No camera feeds available")
		return
	
	feed = feeds[0]
	print(feed)
	
	feed.set_format(0, feed.formats[0])
	feed.feed_is_active = false
	feed.feed_is_active = true
	
	var tex = CameraTexture.new()
	tex.camera_feed_id = feed.get_id()
	tex.camera_is_active = true
	
	$faceScan/cam.texture = tex

func instructions() -> void:
	var list = [
		"Look up",
		"Look left",
		"Look right",
		"Look down"
	]
	
	for i in list:
		$faceScan/action.text = i
		await get_tree().create_timer(4).timeout

	$faceScan/action.text = "Done!"

func _exit_tree() -> void:
	CameraServer.monitoring_feeds = false
	
	if feed:
		feed.feed_is_active = false

func _on_btn_face_scan_pressed() -> void:
	$faceScan.visible = true
	$init.visible = false
	
	await get_tree().create_timer(4).timeout
	await instructions()
	await get_tree().create_timer(3).timeout
	
	$faceScan.visible = false
	$success.visible = true
	
func _on_btn_done_pressed() -> void:
	visible = false
	get_parent().get_node("main").visible = true
