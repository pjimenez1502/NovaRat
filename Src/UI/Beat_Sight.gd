extends Node

const BEAT_MARK = preload("res://Assets/Sprite/Beat_mark.png")

func _ready() -> void:
	BeatDirector.BEAT.connect(on_beat)

func on_beat(beat: int) -> void:
	build_marker(false)
	build_marker(true)


func build_marker(is_right: bool) -> void:
	var beat_marker: Sprite3D = setup_sprite()
	beat_marker.flip_h = is_right
	add_child(beat_marker)
	
	beat_marker.modulate = Color(1, 1, 1, .1)
	beat_marker.position = Vector3(8,0,0) if is_right else Vector3(-8,0,0)
	beat_marker.pixel_size = 0.002
	
	var tween := get_tree().create_tween()
	tween.tween_property(beat_marker, "position", Vector3.ZERO, BeatDirector.sec_per_beat*2)
	tween.parallel().tween_property(beat_marker, "modulate", Color(1, 1, 1, 1), BeatDirector.sec_per_beat*2)
	tween.parallel().tween_property(beat_marker, "pixel_size", 0.008, BeatDirector.sec_per_beat*2)
	
	tween.tween_property(beat_marker, "modulate", Color(1, 1, 1, 0), 0.25)
	
	
	await tween.finished
	beat_marker.queue_free()

func setup_sprite() -> Sprite3D:
	var marker := Sprite3D.new()
	marker.texture = BEAT_MARK
	marker.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	marker.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	marker.fixed_size = true
	return marker
