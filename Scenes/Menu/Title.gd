extends Control

const TutorialScript = preload("res://Scenes/World/Maps/Map1.tscn")


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(TutorialScript)
