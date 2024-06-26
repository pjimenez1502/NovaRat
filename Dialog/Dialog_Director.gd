extends Node

signal DIALOG_SENT

func new_dialog(_character: DialogCharacter, text: String ) -> void:
	DIALOG_SENT.emit()
