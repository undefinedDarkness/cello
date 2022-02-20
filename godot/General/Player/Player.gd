tool
extends VBoxContainer

const FullAlbum = preload("res://General/Library/FullAlbum.gd")

signal paused
signal playing
signal track_changed
signal mini_player_mode

var playback_pos := 0.0
onready var play: Button = $Controls/Play
# onready var art: TextureRect = $AspectRatioContainer/Art
onready var image_size := $AspectRatioContainer/Art.rect_size as Vector2

func _input(event: InputEvent) -> void:
	if Engine.editor_hint:
		return
	if event.is_action_released("ui_accept"):
		_on_Play_pressed()
	elif event.is_action_released("ui_focus_next"):
		_on_Next_pressed()

func _on_Next_pressed():
	Playback.queue_skip_next()

# Actual files dropped from a file manager
func _on_files_dropped(files: PoolStringArray, _screen: int):
	Playback.queue_append_play(files[0])

var track_length: float = 0.0
func update_ui(_path: String, title: String, _album: String, art: ImageTexture, length: float):
	$Title.text = title
	# print(art)
	$AspectRatioContainer/Art.texture = art
	$Tween.remove_all()
	$Tween.interpolate_property($Length, "value", 0.0, 100.0, length)
	$Tween.start()
	track_length = length

func _update_play_button(playing):
	if not playing:
		play.text = "契"
		if $Tween.is_active():
			$Tween.resume_all()
	else:
		play.text = ""
		$Tween.start()

func _ready():
	if Engine.editor_hint:
		return
	var _err = get_tree().connect("files_dropped", self, "_on_files_dropped")
	Playback.connect("track_changed", self, "update_ui")
	Playback.connect("playing", self, "_update_play_button", [ true ])
	Playback.connect("paused", self, "_update_play_button", [ false ])

func _on_Length_gui_input(event: InputEvent):
	if event.is_pressed():
		$Tween.remove_all()
	elif event is InputEventMouseButton:
		Playback.seek(($Length.value/100.0) * track_length)
		$Tween.interpolate_property($Length, "value", $Length.value, 100, (1 - $Length.value/100.0) * track_length)
		$Tween.start()

func _on_Loop_toggled(button_pressed):
	Playback.loop_track = button_pressed

func _on_Autoplay_toggled(button_pressed):
	Playback.autoplay = button_pressed
	
func _on_Play_pressed():
	Playback.play_pause()
		
func can_drop_data(_position, data):
	return data is FullAlbum
	
func drop_data(_position, data: FullAlbum):
	Playback.queue_append_album(data.get_tracks(), 0)

func _on_Mini_Player_Mode_pressed():
	emit_signal("mini_player_mode")

func _on_Back_pressed():
	Playback.queue_skip_previous()
