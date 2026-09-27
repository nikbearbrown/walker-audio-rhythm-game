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
	await create_timer(0.8).timeout
	var checkbox = scene.get_node("Control/SettingsVBox/ShowOffsetCheckBox")
	var before: bool = checkbox.button_pressed
	var point: Vector2 = checkbox.get_global_rect().get_center()
	for pressed in [true, false]:
		var event := InputEventMouseButton.new()
		event.button_index = MOUSE_BUTTON_LEFT
		event.position = point
		event.global_position = point
		event.pressed = pressed
		viewport.push_input(event, true)
		await process_frame
	var passed: bool = checkbox.button_pressed != before
	print("SUBVIEWPORT_MOUSE_OFFSET_TOGGLE ", passed, " POSITION ", point)
	scene.get_node("Conductor").stop()
	await create_timer(0.2).timeout
	viewport.queue_free()
	await process_frame
	await process_frame
	quit(0 if passed else 1)
