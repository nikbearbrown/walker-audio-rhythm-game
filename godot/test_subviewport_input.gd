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
	var manager = scene.get_node("Notes")
	var deadline := Time.get_ticks_msec() + 30000
	var sent := false
	while Time.get_ticks_msec() < deadline:
		await process_frame
		if not manager._notes.is_empty() and abs(manager._get_note_delta(manager._notes[0])) < 0.015:
			var press := InputEventKey.new()
			press.physical_keycode = KEY_SPACE
			press.pressed = true
			Input.parse_input_event(press)
			sent = true
			await process_frame
			await process_frame
			var release := InputEventKey.new()
			release.physical_keycode = KEY_SPACE
			Input.parse_input_event(release)
			break
	var passed: bool = sent and manager._play_stats.perfect_count == 1
	print("SUBVIEWPORT_SPACE_PERFECT ", passed)
	scene.get_node("Conductor").stop()
	await create_timer(0.2).timeout
	viewport.queue_free()
	await process_frame
	await process_frame
	quit(0 if passed else 1)
