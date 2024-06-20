extends Node
class_name ship_stats

@onready var player_ship: player_ship = $".."

@export var hull : float = 60
@export var shield : float = 20

func damage(damage : float) -> void:
	player_ship.animation_player.play("Damage")
	
	shield -= damage
	if shield < 0:
		hull += shield
		shield = 0
	print("hull: ", hull, " shield: ", shield)
	if hull <= 0:
		death()

func death() -> void:
	print("player dead")

var terrain_damage : float = 10
func _on_hit_area_body_entered(body: Node3D) -> void:
	damage(terrain_damage)
	pass # Replace with function body.
