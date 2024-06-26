extends Node

signal DIALOG_SENT
signal DIALOG_HIDE

var characters : Dictionary = {
	"hare": preload("res://Dialog/Characters/Hare.tres"),
	"bird": preload("res://Dialog/Characters/Bird.tres"),
	"lizzard": preload("res://Dialog/Characters/Lizzard.tres"),
}

func new_dialog(_character: String, text: String ) -> void:
	DIALOG_SENT.emit(characters[_character], text)

func hide_dialog() -> void:
	DIALOG_HIDE.emit()
