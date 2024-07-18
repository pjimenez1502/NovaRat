extends Control
class_name funk_machine

const METRONOME_100 = preload("res://Assets/Music/Metronome - 100.mp3")
const KICK = preload("res://Assets/SFX/Kick.ogg")

var bpm: int = 100

var beat_dictionary: Dictionary = {
	"engine": [],	##KICK
	"gun": [],		##HIHAT
	"dash": [],		##SNARE
	"shield": [],	##BASS
}

func _ready() -> void:
	BeatDirector.STREAMBEAT.connect(on_beat)
	audiostreams_setup()
	
	await get_tree().process_frame
	BeatDirector.start_play(METRONOME_100)
	#start_director.call_deferred()

func start_director() -> void:
	BeatDirector.bpm = bpm
	BeatDirector.funkmachine_playing = true

## Audiostreams
var engine_stream: AudioStreamPlayer
var dash_stream: AudioStreamPlayer
var gun_stream: AudioStreamPlayer
var shield_stream: AudioStreamPlayer
func audiostreams_setup() -> void:
	engine_stream = AudioStreamPlayer.new()
	engine_stream.stream = KICK
	get_tree().get_root().add_child.call_deferred(engine_stream)

func on_beat(beat: int) -> void:
	engine_beat(beat)

func engine_beat(beat: int) -> void:
	for enabled_beat: int in beat_dictionary["engine"]:
		if enabled_beat == beat:
			print(beat)
			engine_stream.play()

func enable_beat(tag: String, beat: int) -> void:
	beat_dictionary[tag].append(beat)
