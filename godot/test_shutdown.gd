extends SceneTree

# Diagnostic only, not gameplay footage or perceived audio-sync verification.
func _initialize() -> void:
	run_probe.call_deferred()

func run_probe() -> void:
	var scene = load("res://scenes/main/main.tscn").instantiate()
	root.add_child(scene)
	await create_timer(1.0).timeout
	scene.get_node("Conductor").stop()
	await process_frame
	scene.queue_free()
	await process_frame
	await process_frame
	print("Graceful-stop diagnostic completed")
	quit()
