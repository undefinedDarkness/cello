extends HBoxContainer
class_name Album
var title: String setget , get_title
var tracks_len: int setget , get_tracks_len
var playlist_path

func get_tracks() -> Array:
	return $TracksParent/Tracks.get_children()

func get_title() -> String:
	return $VBoxContainer/PanelContainer/Title.text

func get_tracks_len() -> int:
	return $TracksParent/Tracks.get_child_count()

func get_art() -> Texture:
	return $VBoxContainer/Art.texture

var Track = preload("res://General/Library/Track.tscn")
func add_track(p: String, zip = null):
	var track = Track.instance()
	track.path = p
	if zip:
		track.zip_source = zip
	$TracksParent/Tracks.add_child(track)
	
onready var title_n = $VBoxContainer/PanelContainer/Title
onready var tracks_n = $TracksParent/Tracks
const MaximumTracksInColumn = 7.0 # ????
# Oh, its the maximum no of vertical tracks in the popout
func _ready():
	var meta: TagFile = tracks_n.get_child(0).metadata
	var art = meta.get_album_art()
	var tracks = get_tracks()
	var total_tracks = tracks.size()
	var columns = ceil(total_tracks / MaximumTracksInColumn)
	tracks_n.columns = columns if columns > 1 else 1
	
	if title:
		title_n.text = title
	else:
		title_n.text = meta.get_album()
		if art:
			$VBoxContainer/Art.texture.set_data(art)
	
	for i in range(0, total_tracks):
		var track = tracks[i]
		track.connect("pressed", Global.Player, "play_album", [ tracks, i, $VBoxContainer/Art.texture ])	
		
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
