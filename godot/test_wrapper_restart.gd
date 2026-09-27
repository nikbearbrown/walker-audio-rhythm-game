extends SceneTree

func _initialize() -> void:
	run_probe.call_deferred()

func run_probe() -> void:
	var wrapper = load("res://test_capture_wrapper.tscn").instantiate()
	root.add_child(wrapper)
	current_scene = wrapper
	var before_id: int = wrapper.get_instance_id()
	await create_timer(1.0).timeout
	var event := InputEventKey.new()
	event.physical_keycode = KEY_R
	event.pressed = true
	Input.parse_input_event(event)
	await process_frame
	await process_frame
	await process_frame
	event = InputEventKey.new()
	event.physical_keycode = KEY_R
	Input.parse_input_event(event)
	var reloaded: bool = current_scene.get_instance_id() != before_id
	var viewport = current_scene.get_node("CaptureViewport")
	var game = viewport.get_node("Game")
	var size_ok: bool = viewport.size == Vector2i(3840, 2160)
	print("WRAPPER_RELOAD ", reloaded, " NATIVE_SIZE ", size_ok)
	await create_timer(0.7).timeout
	game.get_node("Conductor").stop()
	await create_timer(0.2).timeout
	current_scene.queue_free()
	await process_frame
	await process_frame
	quit(0 if reloaded and size_ok else 1)
