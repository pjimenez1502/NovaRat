extends Node3D

@export var scene_song: AudioStream

func _ready() -> void:
	await get_tree().process_frame
	BeatDirector.start_play(scene_song)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
