extends Node

func display_text(value: String, position: Vector3, color: Color = "FFF", text_size: float = 12) -> void:
	var combat_text := Label.new()
	combat_text.global_position = get_viewport().get_camera_3d().unproject_position(position)
	combat_text.text = str(value)
	combat_text.z_index = 10
	combat_text.label_settings = LabelSettings.new()
	
	combat_text.label_settings.font_color = color
	combat_text.label_settings.font_size = text_size
	combat_text.label_settings.outline_color = "#000"
	combat_text.label_settings.outline_size = 2
	
	call_deferred("add_child", combat_text)
	
	await combat_text.resized
	combat_text.pivot_offset = Vector2(combat_text.size / 2)
	
	var tween := get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		combat_text, "position:y", combat_text.position.y - 24, 0.25
	).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		combat_text, "position:y", combat_text.position.y, 0.5
	).set_ease(Tween.EASE_IN).set_delay(0.25)
	tween.tween_property(
		combat_text, "scale", Vector2.ZERO, 0.25
	).set_ease(Tween.EASE_IN).set_delay(0.5)
	
	await tween.finished
	combat_text.queue_free()
