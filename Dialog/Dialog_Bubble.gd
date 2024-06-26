extends Control

@onready var portraitRect: TextureRect = $HBoxContainer/PortraitRect
@onready var name_label: Label = $NameLabel
@onready var text_label: Label = $HBoxContainer/TextLabel

func _ready() -> void:
	hide_dialog()
	DialogDirector.DIALOG_SENT.connect(show_dialog)
	DialogDirector.DIALOG_HIDE.connect(hide_dialog)

func show_dialog(_character: DialogCharacter, _text: String) -> void:
	portraitRect.texture = _character.portrait
	name_label.text = _character.name
	text_label.text = _text
	
	visible = true

func hide_dialog() -> void:
	visible = false
