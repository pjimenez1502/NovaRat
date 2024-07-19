extends Control
class_name funk_machine

@onready var time_bar: TextureRect = %TimeBar

const METRONOME_100 = preload("res://Assets/Music/Metronome - 100.mp3")
const KICK_SFX = preload("res://Assets/SFX/Kick.ogg")
const GUN_SFX = preload("res://Assets/SFX/Gun.mp3")
const DASH_SFX = preload("res://Assets/SFX/Dash.mp3")

var beat_dictionary: Dictionary = {
	"ENGINE": [],	##KICK
	"GUN": [],		##HIHAT
	"DASH": [],		##SNARE
	"SHIELD": [],	##BASS
}

func _ready() -> void:
	BeatDirector.STREAMDIV.connect(on_div)
	BeatDirector.STREAMMEASURE.connect(on_measure)
	audiostreams_setup()
	
	await get_tree().process_frame
	start_director(METRONOME_100)
	#start_director.call_deferred()

func start_director(track: AudioStream) -> void:
	BeatDirector.start_play(track)

## Audiostreams
var engine_stream: AudioStreamPlayer
var dash_stream: AudioStreamPlayer
var gun_stream: AudioStreamPlayer
var shield_stream: AudioStreamPlayer
func audiostreams_setup() -> void:
	engine_stream = AudioStreamPlayer.new()
	engine_stream.stream = KICK_SFX
	get_tree().get_root().add_child.call_deferred(engine_stream)
	
	gun_stream = AudioStreamPlayer.new()
	gun_stream.stream = GUN_SFX
	get_tree().get_root().add_child.call_deferred(gun_stream)
	
	dash_stream = AudioStreamPlayer.new()
	dash_stream.stream = DASH_SFX
	get_tree().get_root().add_child.call_deferred(dash_stream)


var timebar_tween: Tween
func on_measure() -> void:
	if timebar_tween:
		timebar_tween.kill()
	
	time_bar.position = Vector2(136,0)
	print(time_bar.position.x)
	
	timebar_tween = get_tree().create_tween()
	timebar_tween.tween_property(time_bar, "position:x", 691, BeatDirector.sec_per_beat*4)

func on_div(beat: int, div: int) -> void:
	engine_beat(beat, div)

func engine_beat(beat: int, div: int) -> void:
	for track: String in beat_dictionary.keys():
		var filtered_beat := filter_beat(beat_dictionary[track], [beat,div])
		if filtered_beat:
			play_track(track, filtered_beat[2])


signal ENGINE
signal GUN
signal DASH
signal SHIELD

func play_track(track: String, dir: int=0) -> void:
	match track:
		"ENGINE":
			engine_stream.play()
			ENGINE.emit()
		"GUN":
			gun_stream.play()
			GUN.emit()
		"DASH":
			dash_stream.play()
			DASH.emit(dir)

func enable_beat(track: String, beat: int, div: int, directional: bool = false) -> int:
	var dir: int = 0
	var filtered_beat := filter_beat(beat_dictionary[track], [beat, div])
	if !filtered_beat:
		dir = 0 if !directional else -1
		beat_dictionary[track].append([beat, div, dir])
		return dir
	dir = 0 if !directional else -filtered_beat[2]
	filtered_beat[2] = dir
	print("Found beat: ", filtered_beat)
	return dir

func disable_beat(track: String, beat: int, div: int) -> void:
	var filtered_beat := filter_beat(beat_dictionary[track], [beat, div])
	if !filtered_beat:
		printerr("Cant disable beat ", beat, " in ", track, ". Not found.")
		return
	beat_dictionary[track].erase(filtered_beat)


func filter_beat(beats: Array, target_beat: Array) -> Array:
	for filtering_beat: Array in beats:
		if filtering_beat[0] == target_beat[0] and filtering_beat[1] == target_beat[1]:
			return filtering_beat
	return []
