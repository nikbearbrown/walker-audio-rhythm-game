extends SceneTree

func _initialize() -> void:
	run_probe.call_deferred()

func run_probe() -> void:
	var recorder := AudioEffectRecord.new()
	recorder.format = AudioStreamWAV.FORMAT_16_BITS
	var slot := AudioServer.get_bus_effect_count(0)
	AudioServer.add_bus_effect(0, recorder)
	var wrapper = load("res://test_capture_wrapper.tscn").instantiate()
	root.add_child(wrapper)
	current_scene = wrapper
	var start_us := Time.get_ticks_usec()
	recorder.set_recording_active(true)
	await create_timer(4.0).timeout
	recorder.set_recording_active(false)
	var requested_s := (Time.get_ticks_usec() - start_us) / 1000000.0
	await create_timer(0.2).timeout
	var recording := recorder.get_recording()
	var result := recording.save_to_wav("/Users/bear/Documents/CoWork/bear-textbooks/books/walker-audio-rhythm-game/evidence/audio-pilot-01/engine-mix-drained.wav")
	print("AUDIO_SAVE_ERROR ", result, " LENGTH ", recording.get_length(), " REQUESTED_S ", requested_s)
	wrapper.get_node("CaptureViewport/Game/Conductor").stop()
	await create_timer(0.2).timeout
	AudioServer.remove_bus_effect(0, slot)
	wrapper.queue_free()
	await process_frame
	await process_frame
	quit(0 if result == OK else 1)
