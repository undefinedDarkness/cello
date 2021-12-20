extends Control

export var audio_stream: NodePath

const VU_COUNT = 5
const FREQ_MAX = 11050.0

const WIDTH = 200
const HEIGHT = 100

const MIN_DB = 60
onready var stream_node = get_node(audio_stream).get_node("Stream")
onready var spectrum = AudioServer.get_bus_effect_instance(0,0)

func _draw():
	#warning-ignore:integer_division
	var w = WIDTH / VU_COUNT
	var prev_hz = 0
	for i in range(1, VU_COUNT+1):
		var hz = i * FREQ_MAX / VU_COUNT;
		var magnitude: float = spectrum.get_magnitude_for_frequency_range(prev_hz, hz).length()
		var energy = clamp((MIN_DB + linear2db(magnitude)) / MIN_DB, 0, 1)
		var height = energy * HEIGHT
		draw_rect(Rect2(w * i, HEIGHT - height, w, height), Color.white)
		prev_hz = hz

func _process(_delta):
	if self.visible == true and stream_node.playing:
		update()
