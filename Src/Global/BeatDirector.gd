extends Node

signal BEAT
signal MEASURE

var output_latency: float
var audio_player: AudioStreamPlayer

var time: float
var beat_position: int
var div_position: int

var subdivisions: int = 4
var sec_per_beat: float
var sec_per_division: float

var delay_tuning: float = 0.1

@export var bpm: float = 60


func _ready() -> void:
	audio_player = AudioStreamPlayer.new()
	get_tree().get_root().add_child.call_deferred(audio_player)
	
	start_play.call_deferred()
	output_latency = AudioServer.get_output_latency()

func _physics_process(delta: float) -> void:
	if audio_player.playing:
		playing()

func playing() -> void:
	time = audio_player.get_playback_position() + AudioServer.get_time_since_last_mix() - delay_tuning
	time -= output_latency
	
	beat_position = int(floor(time / sec_per_beat))
	div_position = int((floor(time / sec_per_division)))
	_report_beat()
	
	stream_time = audio_player.get_playback_position() + AudioServer.get_time_since_last_mix()
	stream_div_pos = int((floor(stream_time / sec_per_division)))
	stream_beat_pos = int(floor(stream_time / sec_per_beat))
	_report_stream_beat()

func start_play(stream: AudioStream) -> void:
	bpm = stream.bpm
	audio_player.stream = stream  #### TRACK TO PLAY
	audio_player.play()
	sec_per_beat = 60 / bpm
	sec_per_division = sec_per_beat / subdivisions

enum ACCURACY { PERFECT, GOOD, OKAY, MISS}
func check_beat_accuracy() -> int:
	var hit_time: float = time / sec_per_division - last_reported_div
	var distance_to_beat: float = hit_time if hit_time <= 0.5 else 1 - hit_time
	#print("hit_time: ", hit_time, " - distance: ",distance_to_beat)
	#print(distance_to_beat)
	var accuracy: int
	if distance_to_beat <= 0.05 :
		accuracy = ACCURACY.PERFECT
		#print("PERFECT")
	elif distance_to_beat <= 0.10 :
		accuracy = ACCURACY.GOOD
		#print("GOOD")
	elif distance_to_beat <= 0.20 :
		accuracy = ACCURACY.OKAY
		#print("OKAY")
	else:
		accuracy = ACCURACY.MISS
		#print("MISS")
	return accuracy


var beat_per_measure: int = 4
var last_reported_div: int = 0
var beat: int = -2
var measure: int = 0
var last_measure: int = -1
var start_delay: int = 2

func _report_beat() -> void:  ##DELAY ALL BY TWO BEATS (Time between new beat spawn and them arriving to the center)
	if last_reported_div >= div_position:
		return
	last_reported_div = div_position
	
	if (div_position % subdivisions) == 0:
		#print("beat - ", beat_position % beat_per_measure +1)
	
		if (beat_position % beat_per_measure) == 0:
			MEASURE.emit(measure)
			#print("measure: ", measure)
			measure += 1
			return
	
		BEAT.emit(beat_position % beat_per_measure +1)
		return
	#DIV.emit


signal STREAMBEAT
signal STREAMDIV
signal STREAMMEASURE
var stream_time: float
var stream_div_pos: int
var stream_beat_pos: int

var last_stream_div: int
var last_stream_beat: int = 2

var stream_measurebeat: int = 3
func _report_stream_beat() -> void:
	if last_stream_div >= stream_div_pos:
		return
	last_stream_div = stream_div_pos
	
	stream_beat_pos = stream_beat_pos +2 ##Starting song offset
	if stream_beat_pos != last_stream_beat:
		last_stream_beat = stream_beat_pos
		stream_measurebeat = stream_beat_pos % beat_per_measure
		
		STREAMBEAT.emit(stream_measurebeat+1)
		
		if stream_measurebeat == 0:
			STREAMMEASURE.emit()
	
	STREAMDIV.emit(stream_measurebeat+1, stream_div_pos % subdivisions +1)
