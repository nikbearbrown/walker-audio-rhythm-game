extends SceneTree

# Engine input diagnostic, not captured gameplay or human listening evidence.
func _initialize() -> void:
	run_probe.call_deferred()

func press_pause() -> void:
	var event := InputEventKey.new()
	event.physical_keycode = KEY_P
	event.pressed = true
	Input.parse_input_event(event)
	await process_frame
	await process_frame
	event = InputEventKey.new()
	event.physical_keycode = KEY_P
	event.pressed = false
	Input.parse_input_event(event)
	await process_frame

func run_probe() -> void:
	var scene = load("res://scenes/main/main.tscn").instantiate()
	root.add_child(scene)
	await create_timer(1.0).timeout
	await press_pause()
	var pause_ok: bool = paused and scene.get_node("Control/PauseLabel").visible
	await press_pause()
	var resume_ok: bool = not paused and not scene.get_node("Control/PauseLabel").visible
	print("INPUT_PAUSE ", pause_ok, " INPUT_RESUME ", resume_ok)
	paused = false
	scene.get_node("Conductor").stop()
	# Give the audio thread time to release playback before freeing the scene.
	await create_timer(0.2).timeout
	scene.queue_free()
	await process_frame
	await process_frame
	quit(0 if pause_ok and resume_ok else 1)
