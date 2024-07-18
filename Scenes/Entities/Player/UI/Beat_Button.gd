extends Control

@onready var button: TextureButton = $Button
@onready var guide: TextureRect = $Guide
@onready var on: TextureRect = $ON

@export var _funk_machine: funk_machine
@export var beat: int = 1
@export var div: int = 1

func _ready() -> void:
	button.gui_input.connect(_on_Button_gui_input)

func toggle(value: bool) -> void:
	on.visible = value
	_funk_machine.enable_beat("engine", beat)

func _on_on_mouse_entered() -> void:
	guide.visible = true
func _on_on_mouse_exited() -> void:
	guide.visible = false

func _on_Button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			toggle(true)
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			toggle(false)
