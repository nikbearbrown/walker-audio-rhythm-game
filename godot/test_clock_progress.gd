extends SceneTree

# Read-only clock diagnostic, not audiovisual evidence or a capture driver.
func _initialize() -> void:
	run_probe.call_deferred()

func run_probe() -> void:
	var scene = load("res://scenes/main/main.tscn").instantiate()
	root.add_child(scene)
	current_scene = scene
	await create_timer(1.0).timeout
	var conductor = scene.get_node("Conductor")
	var start_us := Time.get_ticks_usec()
	var start_raw: float = conductor.get_current_beat_raw()
	var start_filtered: float = conductor.get_current_beat()
	for sample in range(5):
		await create_timer(1.0).timeout
		var wall_s := (Time.get_ticks_usec() - start_us) / 1000000.0
		var raw_s: float = (conductor.get_current_beat_raw() - start_raw) * conductor.get_beat_duration()
		var filtered_s: float = (conductor.get_current_beat() - start_filtered) * conductor.get_beat_duration()
		print("CLOCK_SAMPLE wall_s=", wall_s, " raw_s=", raw_s, " filtered_s=", filtered_s)
	conductor.stop()
	await create_timer(0.2).timeout
	scene.queue_free()
	await process_frame
	await process_frame
	quit()
