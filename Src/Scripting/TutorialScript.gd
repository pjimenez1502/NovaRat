extends Node

@onready var staging_timer: Timer = $Timer


func _ready() -> void:
	phase_1()


func phase_1() -> void:
	await get_tree().create_timer(10).timeout
	DialogDirector.new_dialog("lizzard","Alright Cadet, \nlooks like takeoff went without issues.")
	
	await get_tree().create_timer(8).timeout
	DialogDirector.new_dialog("lizzard","I will be your instructor today. \nFollow my directions and you will end your first flight in one piece.")
	
	await get_tree().create_timer(8).timeout
	DialogDirector.new_dialog("lizzard","Let's test your basic controls. \nMove your joystick to manouver the ship.")
	
	await get_tree().create_timer(8).timeout
	DialogDirector.new_dialog("lizzard","Good. \nYou can Roll to turn without messing your aim \nor to simply turn faster.")
	
	await get_tree().create_timer(8).timeout
	DialogDirector.new_dialog("lizzard","Use your thrusters to speed up and slow down.")
	
	
	
	await get_tree().create_timer(8).timeout
	DialogDirector.new_dialog("lizzard","Press the trigger to fire your main weapons. \nWeapons free, you are authorized to shoot.")
	
	await get_tree().create_timer(8).timeout
	DialogDirector.new_dialog("lizzard","Your secondary weapons will see less use, \nbut they usually pack a bigger punch than your primary ones.")
	await get_tree().create_timer(8).timeout
	DialogDirector.new_dialog("lizzard","You will have to choose what to carry \nbefore you leave the carrier.\nEvery type of ordinance will be useful \nin different situations.")
	await get_tree().create_timer(8).timeout
	DialogDirector.new_dialog("lizzard","Learning which one is right for the mission and when to employ them\n is a crucial skill you will develop with experience.")
	 


