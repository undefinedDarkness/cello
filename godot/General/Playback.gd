extends Node

signal track_changed(filepath, title, artist, art)
# signal queue_over
signal playing
signal paused

# var FLACSupport = preload("res://Assets/flac_support.gdns").new()

func _raw_load_file(filepath: String, bytes = null) -> AudioStream:
	
	var ext := filepath.get_extension()
	var stream: AudioStream
	
	if ext == "mp3":
		stream = AudioStreamMP3.new()
	elif ext == "ogg":
		stream = AudioStreamOGGVorbis.new()
	elif ext == "flac":
		# print(FLACSupport)
		#stream = FLACSupport.create_sample(filepath)
		return stream
	
	if bytes == null:
		var f = File.new()
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

var _current_track: AlbumTrack
var _player: AudioStreamPlayer = AudioStreamPlayer.new()

# add player node to self or it won't work
func _ready():
	add_child(_player)
	_player.connect("finished", self, "_on_Stream_finished")

func _play_file(track) -> void:
	if not track:
		return
	
	if not track is AlbumTrack:
		var _p = track
		track = AlbumTrack.new()
		track.path = _p
		track._ready()
	
	var path: String = track.path
		
	if _current_track and track.path == _current_track.path:
		return
	else:
		_current_track = track
	
	var stream := _raw_load_file(track.path)
	_player.stream = stream
	track.length = stream.get_length()
	emit_signal("track_changed", track.path, track.title, track.album, track.art, track.length)

var _queue := []
export var loop_track: bool = false
export var auto_play: bool = true
func _on_Stream_finished() -> void:
	if loop_track == true:
		_player.play(0.0)
	elif _queue.size() > 0 and auto_play:
		queue_skip_next()

var index: int = 0
func queue_append_album(tracks: Array, track_index: int) -> void:
	# print("Currently ", _queue.size(), " tracks in queue. Adding ", tracks.size(), " more. Index: ", index)
	index = _queue.size() + track_index
	
	for i in range(0, _queue.size()):
		if _queue[i] == tracks[track_index]:
			index = i-1
			queue_skip_next()
			print("Found track in queue already at index ", index)
	
	for i in range(0, tracks.size()):
		_queue.push_back(tracks[i] as AlbumTrack)
	queue_skip_next()

func queue_append_play(p: String) -> void:
	_queue.push_back(p)
	if not _player.playing:
		queue_skip_next()

func seek(where: float) -> void:
	_player.seek(where)

func seek_with_offset(offset: float) -> void:
	_player.seek(_player.get_playback_position() + offset)
	
func queue_skip_next() -> void:
	_play_file(_queue[index])
	if not _player.playing:
		_player.play(0.0)
		emit_signal("playing")
	index+=1
	
func queue_skip_previous() -> void:
	pass #index-=1
	#queue_skip_next()
	
func is_playing() -> bool:
	return _player.playing
	
var _last_pos: float
func play_pause() -> void:
	if _player.playing:
		_last_pos = _player.get_playback_position()
		_player.stop()
		emit_signal("paused")
	else:
		_player.play(_last_pos)
		emit_signal("playing")

func pause() -> void:
	if _player.playing:
		_last_pos = _player.get_playback_position()
		_player.stop()
		emit_signal("paused")

func play() -> void:
	if not _player.playing:
		_player.play(_last_pos)
		emit_signal("playing")
	
