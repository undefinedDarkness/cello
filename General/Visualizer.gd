extends Control

export var VU_COUNT := 16 
export var spacing := 8 
export var color := Color.white
const FREQ_MAX = 11050.0

var WIDTH = 400
var HEIGHT = 100

const MIN_DB = 60

var spectrum

var w #= WIDTH / VU_COUNT
var prev_hz = 0
func _draw():
	for i in range(1, VU_COUNT+1):
		var hz = i * FREQ_MAX / VU_COUNT;
		var magnitude: float = spectrum.get_magnitude_for_frequency_range(prev_hz, hz).length()
		var energy = clamp((MIN_DB + linear2db(magnitude)) / MIN_DB, 0, 1)
		var height = energy * HEIGHT
		draw_rect(Rect2((w+spacing) * (i-1), HEIGHT - height, w, height), color)
		prev_hz = hz

func _ready():
	spectrum = AudioServer.get_bus_effect_instance(0,0)
	Global.Player.connect("playing", self, 'on_playing')
	Global.Player.connect("paused", self, 'on_paused')

# Reduce overhead by turning off process() entirely
onready var nothing = $"Nothing Playing"
func on_paused():
	set_process(false)
	nothing.visible = true

func on_playing():
	set_process(true)
	nothing.visible = false

func _process(_delta):
	update()
	
func _on_Control_resized():
	WIDTH = rect_size[0]
	HEIGHT = rect_size[1]
	w = (WIDTH-(spacing*VU_COUNT)) / VU_COUNT


func _on_Control_visibility_changed():
	if not visible:
		set_process(false)
	elif Global.Player.get_node('Stream').is_playing():
		set_process(true)
