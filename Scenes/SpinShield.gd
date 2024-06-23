extends Area3D

@onready var collision: CollisionShape3D = $Collision



func shield_up() -> void:
	collision.disabled = false

func shield_down() -> void:
	collision.disabled = true


func _on_body_entered(body: Node3D) -> void:
	print("weow: ", body)
	body.set_collision_disabled(true)
	
	var x := randf_range(0, TAU)
	var y := randf_range(0, TAU)
	var z := randf_range(0, TAU)
	body.rotation = Vector3(x, y, z)
