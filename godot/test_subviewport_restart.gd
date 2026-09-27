extends SceneTree

func _initialize() -> void:
	run_probe.call_deferred()

func run_probe() -> void:
	var viewport := SubViewport.new()
	viewport.size = Vector2i(3840, 2160)
	viewport.size_2d_override = Vector2i(1280, 720)
	viewport.size_2d_override_stretch = true
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(viewport)
	var scene = load("res://scenes/main/main.tscn").instantiate()
	viewport.add_child(scene)
	current_scene = scene
	var before_id: int = scene.get_instance_id()
	await create_timer(1.0).timeout
	var press := InputEventKey.new()
	press.physical_keycode = KEY_R
	press.pressed = true
	Input.parse_input_event(press)
	await process_frame
	await process_frame
	await process_frame
	var release := InputEventKey.new()
	release.physical_keycode = KEY_R
	Input.parse_input_event(release)
	var reloaded: bool = is_instance_valid(current_scene) and current_scene.get_instance_id() != before_id
	var retained_viewport: bool = reloaded and current_scene.get_viewport() == viewport
	print("RELOADED ", reloaded, " RETAINED_CAPTURE_VIEWPORT ", retained_viewport)
	if is_instance_valid(current_scene):
		await create_timer(0.7).timeout
		current_scene.get_node("Conductor").stop()
		await create_timer(0.2).timeout
		current_scene.queue_free()
	viewport.queue_free()
	await process_frame
	await process_frame
	quit(0 if reloaded and retained_viewport else 1)
