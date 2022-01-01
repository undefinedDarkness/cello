extends VBoxContainer

signal paused
signal playing

var f := File.new()
var playback_pos := 0.0
onready var play: Button = $Controls/Play
onready var art: TextureRect = $AspectRatioContainer/Art
onready var image_size := art.rect_size
var current_file: String
var queue := []

# I really want to clean this mess of code but its too convienient
func raw_load_file(filepath: String, bytes = null) -> AudioStream:
	
	var ext := filepath.get_extension()
	var stream: AudioStream
	
	if ext == "mp3":
		stream = AudioStreamMP3.new()
	elif ext == "ogg":
		stream = AudioStreamOGGVorbis.new()
	elif ext == "flac":
		stream = AudioStreamFLAC.new()
	
	if bytes == null:
		var err = f.open(filepath, File.READ)
	
		if err != OK:
			printerr(err, filepath)
			f.close()
			return AudioStreamSample.new()
		stream.data = f.get_buffer(f.get_len())
		f.close()
	else:
		stream.data = bytes
	
	return stream

# TODO: Use errors
func play_file(track, stop_playback = true) -> void:
	if not track:
		return
	
	var path: String = track.path if track is AlbumTrack else track
		
	if path == current_file:
		return
	else:
		current_file = path
	
	var stream: AudioStream
	if track is AlbumTrack and track.zip_source != null:
		stream = raw_load_file(current_file, track.zip_source.read_file(track.path.split('::')[1]))
	else:
		stream = raw_load_file(current_file)
	#(stream)
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
		emit_signal("playing")
	
	if track is AlbumTrack and track.metadata:
		$Title.text = track.metadata.get_title()
		$AspectRatioContainer.hint_tooltip = track.metadata.get_artist()
	else:
		var tag_f := TagFile.new()
		tag_f.open_path(ProjectSettings.globalize_path(current_file))
		
		var image = tag_f.get_album_art()
		if image:
			art.texture.set_data(image)
			
		$Title.text = tag_f.get_title()
		tag_f.close()
		
func queue_append_play(p: String) -> void:
	queue.push_back(p)
	if not $Stream.playing:
		play_file(queue.pop_front())

func _on_Ticker_timeout() -> void:
	$Length.value += 1
	$Ticker.start()

var loop_track := false
var autoplay := true

func play_album(tracks: Array, index: int, album_art: Texture) -> void:
	art.texture = album_art
	#var tracks = tracksList.get_children()
	
	queue = []
	for i in range(index, tracks.size()):
		queue.push_back(tracks[i] as AlbumTrack)
	play_file(queue.pop_front(), not autoplay)

func _input(event: InputEvent) -> void:
	if event.is_action_released("ui_accept"):
		_on_Play_pressed()
	elif event.is_action_released("ui_focus_next"):
		_on_Next_pressed()

func _on_Stream_finished() -> void:
	$Ticker.stop()
	#emit_signal("paused")
	if loop_track == true:
		$Stream.play(0.0)
		playback_pos = 0.0
		$Length.value = 0.0
	elif queue.size() > 0:
		play_file(queue.pop_front(), not autoplay)

func _on_Next_pressed():
	play_file(queue.pop_front(), not autoplay)

# Actual files dropped from a file manager
func _on_files_dropped(files: PoolStringArray, _screen: int):
	queue_append_play(files[0])

func _ready():
	var _err = get_tree().connect("files_dropped", self, "_on_files_dropped")
	#queue_append_play("res://Assets/test.mp3")
	Global.Player = self

func _on_Length_gui_input(event: InputEvent):
	if event.is_pressed():
		$Stream.seek($Length.value)

func _on_Loop_toggled(button_pressed):
	loop_track = button_pressed

func _on_Autoplay_toggled(button_pressed):
	autoplay = button_pressed
	
func _on_Play_pressed():
	if $Stream.stream == null:
		return
	
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
		
func can_drop_data(_position, data):
	return data is Album
	
func drop_data(_position, data: Album):
	play_album(data.get_tracks(), 0, data.get_art())
