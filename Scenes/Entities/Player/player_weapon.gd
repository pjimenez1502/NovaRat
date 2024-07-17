extends ship_weapon
class_name player_weapon

func set_bpm() -> void:
	rpm = BeatDirector.bpm * BeatDirector.subdivisions

func shoot() -> void:
	var beat_accuracy := BeatDirector.check_beat_accuracy()
	
	FloatingTextDirector.display_text(BeatDirector.ACCURACY.keys()[beat_accuracy], get_parent().global_position + Vector3(0.3, 0.2, -2), Color.WHITE, 20)
	match beat_accuracy:
		BeatDirector.ACCURACY.PERFECT:
			super.shoot()
		BeatDirector.ACCURACY.GOOD:
			super.shoot()
		BeatDirector.ACCURACY.OKAY:
			super.shoot()
		BeatDirector.ACCURACY.MISS:
			#super.shoot()
			pass

