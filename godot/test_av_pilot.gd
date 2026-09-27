extends SceneTree

const OUTPUT = "/Users/bear/Documents/CoWork/bear-textbooks/books/walker-audio-rhythm-game/evidence/av-pilot-03/"

func _initialize() -> void:
	run_probe.call_deferred()

func run_probe() -> void:
	root.close_requested.connect(func(): print("CAPTURE_WINDOW_CLOSE_REQUESTED"))
	var wrapper = load("res://test_capture_wrapper.tscn").instantiate()
	root.add_child(wrapper)
	current_scene = wrapper
	var viewport = wrapper.get_node("CaptureViewport")
	var recorder := AudioEffectRecord.new()
	recorder.format = AudioStreamWAV.FORMAT_16_BITS
	var slot := AudioServer.get_bus_effect_count(0)
	AudioServer.add_bus_effect(0, recorder)
	await create_timer(1.0).timeout
	var log_file := FileAccess.open(OUTPUT + "timestamps.jsonl", FileAccess.WRITE)
	var input_log := FileAccess.open(OUTPUT + "inputs.jsonl", FileAccess.WRITE)
	var manager = wrapper.get_node("CaptureViewport/Game/Notes")
	var sent := false
	var release_pending := false
	var start_us := Time.get_ticks_usec()
	recorder.set_recording_active(true)
	var count := 0
	var next_us := start_us
	while Time.get_ticks_usec() - start_us < 20000000:
		await RenderingServer.frame_post_draw
		var now := Time.get_ticks_usec()
		if release_pending:
			var release := InputEventKey.new()
			release.physical_keycode = KEY_SPACE
			Input.parse_input_event(release)
			input_log.store_line(JSON.stringify({"time_s":(now-start_us)/1000000.0,"key":"Space","pressed":false}))
			release_pending = false
		elif not sent and not manager._notes.is_empty() and abs(manager._get_note_delta(manager._notes[0])) < 0.020:
			var press := InputEventKey.new()
			press.physical_keycode = KEY_SPACE
			press.pressed = true
			Input.parse_input_event(press)
			input_log.store_line(JSON.stringify({"time_s":(now-start_us)/1000000.0,"key":"Space","pressed":true}))
			sent = true
			release_pending = true
		if now < next_us:
			continue
		var frame = viewport.get_texture().get_image()
		var filename := "frame-%04d.jpg" % count
		var result: int = frame.save_jpg(OUTPUT + filename, 0.95)
		log_file.store_line(JSON.stringify({"frame": filename, "time_s": (now-start_us)/1000000.0, "save_error":result}))
		count += 1
		next_us = now + 66667
	recorder.set_recording_active(false)
	var end_s := (Time.get_ticks_usec()-start_us)/1000000.0
	await create_timer(0.2).timeout
	var recording := recorder.get_recording()
	var error := recording.save_to_wav(OUTPUT + "engine-mix.wav")
	log_file.store_line(JSON.stringify({"end_s":end_s,"audio_s":recording.get_length(),"frames":count,"audio_save_error":error}))
	log_file.close()
	input_log.store_line(JSON.stringify({"perfect_count":manager._play_stats.perfect_count,"sent":sent}))
	input_log.close()
	print("AV_PILOT frames=", count, " wall_s=", end_s, " audio_s=", recording.get_length())
	wrapper.get_node("CaptureViewport/Game/Conductor").stop()
	await create_timer(0.2).timeout
	AudioServer.remove_bus_effect(0,slot)
	wrapper.queue_free()
	await process_frame
	await process_frame
	quit(error)
