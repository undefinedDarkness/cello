extends VBoxContainer

signal paused
signal playing

var f = File.new()
func raw_load_file(filepath: String) -> AudioStream:
	var err = f.open(filepath, File.READ)
	
	if err != OK:
		printerr(err, filepath)
		f.close()
		return AudioStreamSample.new()
	
	var ext = filepath.get_extension()
	var stream: AudioStream
	
	if ext == "mp3":
		stream = AudioStreamMP3.new()
	elif ext == "ogg":
		stream = AudioStreamOGGVorbis.new()
	elif ext == "flac":
		stream = AudioStreamFLAC.new()
	
	stream.data = f.get_buffer(f.get_len())
	f.close()
	
	return stream

var playback_pos: float = 0.0
onready var play = $Controls/Play
func _on_Play_pressed():
	if play.text == "契":
		$Stream.play(playback_pos)
		$Stream.stream_paused = false
		$Ticker.start()
		play.text = ""
		emit_signal("playing")
	else:
		playback_pos = $Stream.get_playback_position()
		$Ticker.stop()
		$Stream.stream_paused = true
		play.text = "契"
		emit_signal("paused")

onready var art = $AspectRatioContainer/Art
onready var image_size = art.rect_size
var current_file: String
func play_file(track, stop_playback = true):
	if not track:
		return
	
	var path = track
	if track is AlbumTrack:
		path = track.path
		
	if path == current_file:
		return
	else:
		current_file = path
	
	var stream = raw_load_file(current_file)
	$Stream.stream = stream
	playback_pos = 0.0
	$Length.max_value = stream.get_length()
	$Length.value = playback_pos
	
	if stop_playback == true:
		play.text = "契"
		$Ticker.stop()
		emit_signal("paused")
	else:
		$Stream.play()
		play.text = ""
	
	var tag_f: TagFile
	if track is AlbumTrack and track.metadata:
		$Title.text = track.metadata.get_title()
	else:
		tag_f = TagFile.new()
		tag_f.open_path(ProjectSettings.globalize_path(current_file))
		
		# Can cause errors but mehhh
		var image = tag_f.get_album_art()
		if image:
			#image.crop(image_size[0], image_size[1])
			art.texture.set_data(image)
			
		$Title.text = tag_f.get_title()
		tag_f.close()

var queue: Array = []
func queue_append_play(p: String):
	queue.push_back(p)
	if not $Stream.playing:
		play_file(queue.pop_front())

func _on_files_dropped(files: PoolStringArray, _screen: int):
	queue_append_play(files[0])

func _ready():
	var _err = get_tree().connect("files_dropped", self, "_on_files_dropped")
	#queue_append_play("res://Assets/test.mp3")
	Global.Player = self

func _on_Ticker_timeout():
	$Length.value += 1
	$Ticker.start()

var loop_track: bool = false
var autoplay: bool = true
func _on_Stream_finished():
	$Ticker.stop()
	emit_signal("paused")
	if loop_track == true:
		$Stream.play(0.0)
		playback_pos = 0.0
		$Length.value = 0.0
	elif queue.size() > 0:
		play_file(queue.pop_front(), not autoplay)

func _on_Length_gui_input(event: InputEvent):
	if event.is_pressed():
		$Stream.seek($Length.value)

# OPTIMIZE THIS >.<
# as in don't load the entire album each time
func play_album(tracksList: Container, index: int, album_art: Texture):
	art.texture = album_art
	var tracks = tracksList.get_children()
	
	queue = []
	for i in range(index, tracks.size()):
		queue.push_back(tracks[i] as AlbumTrack)
	play_file(queue.pop_front(), not autoplay) # Don't load metadata

func _on_Loop_toggled(button_pressed):
	loop_track = button_pressed

func _on_Next_pressed():
	play_file(queue.pop_front(), not autoplay)

func _on_Autoplay_toggled(button_pressed):
	autoplay = button_pressed
