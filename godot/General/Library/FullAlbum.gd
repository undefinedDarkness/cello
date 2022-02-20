extends Control
# class_name Album
var title: String setget , get_title
var tracks_len: int setget , get_tracks_len
var playlist_path
var art_path  = null

func get_tracks() -> Array:
	return $TracksParent/Tracks.get_children()

func get_track_paths() -> PoolStringArray:
	var a: PoolStringArray = []
	for track in get_tracks():
		a.push_back((track as AlbumTrack).path)
	return a

func get_title() -> String:
	return $VBoxContainer/PanelContainer/Title.text

func get_tracks_len() -> int:
	return $TracksParent/Tracks.get_child_count()

var Track = preload("res://General/Library/Track.tscn")
func add_track(p: String):
	var track = Track.instance()
	track.path = p
	# if zip:
	#	track.zip_source = zip
	$TracksParent/Tracks.add_child(track)
	
onready var title_n = $VBoxContainer/PanelContainer/Title
onready var tracks_n = $TracksParent/Tracks
const MaximumTracksInColumn = 7.0 # ????
# Oh, its the maximum no of vertical tracks in the popout

var art: ImageTexture
func _ready():
	var meta := tracks_n.get_child(0) as AlbumTrack# .metadata
	
	if art:
		pass
	else:
		meta.get_art()
		art = meta.art
		
	var tracks := get_tracks()
	var total_tracks := tracks.size()
	var columns = ceil(total_tracks / MaximumTracksInColumn) + 1
	tracks_n.columns = columns if columns > 1 else 1
	
	if meta.album and not title:
		title = meta.album
		if art:
			$VBoxContainer/Art.texture = art
		
	title_n.text = title # .empty() or "Unnamed"
	
	for i in range(0, total_tracks):
		var track = tracks[i]
		
		if not track.art:
			if title != "Unsorted":
				track.art = art
			else:
				track.get_art()
		track.connect("pressed", Playback, "queue_append_album", [ tracks, i ])	
		
func get_drag_data(_position):
	# TODO: Get a preview working.
	return self

func _on_Album_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed == true and event.button_index == BUTTON_LEFT:
		var is_visible = $TracksParent.visible
		if not is_visible:
			$TracksParent.visible = true
		else:
			$TracksParent.visible = false


