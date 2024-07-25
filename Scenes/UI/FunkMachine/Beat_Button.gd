extends Control
class_name beat_button

@onready var button: TextureButton = $Button
@onready var guide: TextureRect = $Guide
@onready var on: TextureRect = $ON
@onready var left: TextureRect = $Left
@onready var right: TextureRect = $Right


@export var _funk_machine: funk_machine

enum TRACKS { JUMP, DUCK, DASH, SHIELD}
@export var track: TRACKS
@export var beat: int = 1
@export var div: int = 1

@export var directional: bool

func _ready() -> void:
	button.gui_input.connect(_on_Button_gui_input)

func enable() -> void:
	var dir := _funk_machine.enable_beat(TRACKS.keys()[track], beat, div, directional)
	match dir:
		0:
			on.visible = true
			left.visible = false
			right.visible = false
		1:
			on.visible = false
			left.visible = false
			right.visible = true
		-1:
			on.visible = false
			left.visible = true
			right.visible = false

func disable() -> void:
	on.visible = false
	left.visible = false
	right.visible = false
	_funk_machine.disable_beat(TRACKS.keys()[track], beat, div)

## LISTEN TO A SIGNAL FROM FUNK MACHINE TELLING EACH BUTTON WHEN THEY ARE ENABLED OR DISABLED

func _on_on_mouse_entered() -> void:
	guide.visible = true
func _on_on_mouse_exited() -> void:
	guide.visible = false

func _on_Button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			enable()
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			disable()
