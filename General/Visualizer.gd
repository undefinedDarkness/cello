extends Control

export var VU_COUNT: int = 16 
export var spacing: int = 8 
export var color: Color = Color.white
const FREQ_MAX = 11050.0

var WIDTH = 400
var HEIGHT = 100

const MIN_DB = 60

var spectrum

var w #= WIDTH / VU_COUNT
var prev_hz = 0
func _draw():
	#warning-ignore:integer_division
	#var w = WIDTH / VU_COUNT
	#var prev_hz = 0
	for i in range(1, VU_COUNT+1):
		var hz = i * FREQ_MAX / VU_COUNT;
		var magnitude: float = spectrum.get_magnitude_for_frequency_range(prev_hz, hz).length()
		var energy = clamp((MIN_DB + linear2db(magnitude)) / MIN_DB, 0, 1)
		var height = energy * HEIGHT
		draw_rect(Rect2((w+spacing) * (i-1), HEIGHT - height, w, height), color)
		prev_hz = hz

var playing: bool = false
func set_p(v: bool):
	playing = v

func _ready():
	spectrum = AudioServer.get_bus_effect_instance(0,0)
	
	# Hide when not playing
	Global.Player.connect("paused", self, 'set_p', [ false ])
	Global.Player.connect("playing", self, 'set_p', [ true ])

onready var stream: AudioStreamPlayer = Global.Player.get_node("Stream")
func _process(_delta):
	if self.visible == true and self.playing == true:
		update()

func _on_Control_resized():
	WIDTH = rect_size[0]
	HEIGHT = rect_size[1]
	w = (WIDTH-(spacing*VU_COUNT)) / VU_COUNT
