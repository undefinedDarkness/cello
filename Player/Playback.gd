extends VBoxContainer

func raw_load_file(filepath: String) -> AudioStream:
	var file = File.new()
	var err = file.open(filepath, File.READ)
	
	if err != OK:
		printerr(err, filepath)
		file.close()
		return AudioStreamSample.new()

	var bytes: PoolByteArray = file.get_buffer(file.get_len())
	file.close()
	
	var ext = filepath.get_extension()
	var stream: AudioStream
	
	if ext == "mp3":
		stream = AudioStreamMP3.new()
	elif ext == "ogg":
		stream = AudioStreamOGGVorbis.new()
	elif ext == "flac":
		stream = AudioStreamFLAC.new()
	
	stream.data = bytes
	
	return stream

var playback_pos: float = 0.0
onready var play = $Controls/Play
func _on_Play_pressed():
	if play.text == "Play":
		$Stream.play(playback_pos)
		$Ticker.start()
		play.text = "Pause"
	else:
		playback_pos = $Stream.get_playback_position()
		$Stream.stop()
		$Ticker.stop()
		play.text = "Play"

var tag_f = TagFile.new()
onready var art = $AspectRatioContainer/Art
onready var default_texture = art.texture
func load_file(file: String):
	var stream = raw_load_file(file)
	$Stream.stream = stream
	play.text = "Play"
	playback_pos = 0.0
	$Length.max_value = stream.get_length()
	$Length.value = playback_pos
	$Ticker.stop()
	
	tag_f.open_path(ProjectSettings.globalize_path(file))
	
	var image = tag_f.get_album_art()
	if image:
		var texture = ImageTexture.new()
		texture.create_from_image(image)
		art.texture = texture
	else:
		art.texture = default_texture
		
	$Title.text = tag_f.get_title()

func _on_files_dropped(files: PoolStringArray, _screen: int):
	load_file(files[0])

func _ready():
	get_tree().connect("files_dropped", self, "_on_files_dropped")
	load_file("res://Assets/test.mp3")

func _on_Ticker_timeout():
	$Length.value += 1
	$Ticker.start()

var loop_track: bool = false
func _on_Stream_finished():
	$Ticker.stop()
	if loop_track == true:
		$Stream.play(0.0)
		playback_pos = 0.0
		$Length.value = 0.0

func _on_Length_gui_input(event: InputEvent):
	if event.is_pressed():
		$Stream.seek($Length.value)


func _on_Loop_toggled(button_pressed):
	loop_track = button_pressed
