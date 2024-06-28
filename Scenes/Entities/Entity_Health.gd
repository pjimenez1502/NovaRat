extends Node
class_name entity_health

@export var entity : Node3D

@export var BASE_HP : int = 4
@export var BASE_SHIELD : int = 0
var hp : int
var shield: int

@export var immunity_period : float = 0.2
var immune : bool

func init_hp() -> void:
	hp = BASE_HP
	shield = BASE_SHIELD

func damage(damage: int, damager_group: String) -> void:
	if immune:
		return
	
	entity.animation_player.play("Damage")
	hp -= damage
	if hp <= 0:
		entity.death(damager_group)
	
	immune = true
	await get_tree().create_timer(immunity_period).timeout
	immune = false
