extends SceneTree

# Actual engine still at native render size; not motion or audio evidence.
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
	await create_timer(2.0).timeout
	await RenderingServer.frame_post_draw
	var frame := viewport.get_texture().get_image()
	print("SUBVIEWPORT_PIXELS ", frame.get_size())
	var result := frame.save_png("/Users/bear/Documents/CoWork/bear-textbooks/books/walker-audio-rhythm-game/evidence/subviewport-pilot-01/actual-engine.png")
	print("PNG_SAVE_ERROR ", result)
	scene.get_node("Conductor").stop()
	await create_timer(0.2).timeout
	viewport.queue_free()
	await process_frame
	await process_frame
	quit(0 if result == OK and frame.get_size() == Vector2i(3840, 2160) else 1)
