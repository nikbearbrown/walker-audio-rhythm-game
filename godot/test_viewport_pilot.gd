extends SceneTree

# Diagnostic still of the actual rendered scene, not gameplay coverage.
func _initialize() -> void:
	run_probe.call_deferred()

func run_probe() -> void:
	root.size = Vector2i(3840, 2160)
	var scene = load("res://scenes/main/main.tscn").instantiate()
	root.add_child(scene)
	current_scene = scene
	await create_timer(2.0).timeout
	await RenderingServer.frame_post_draw
	var frame := root.get_texture().get_image()
	print("VIEWPORT_PIXELS ", frame.get_size())
	var result := frame.save_png("/Users/bear/Documents/CoWork/bear-textbooks/books/walker-audio-rhythm-game/evidence/viewport-pilot-01/actual-engine.png")
	print("PNG_SAVE_ERROR ", result)
	scene.get_node("Conductor").stop()
	await create_timer(0.2).timeout
	scene.queue_free()
	await process_frame
	await process_frame
	quit(0 if result == OK and frame.get_size() == Vector2i(3840, 2160) else 1)
