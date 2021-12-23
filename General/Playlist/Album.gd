extends HBoxContainer

func get_tracks_len():
	return $TracksParent/Tracks.get_child_count()

var Track = preload("res://General/Playlist/Track.tscn")
func add_track(p: String):
	var track = Track.instance()
	track.path = p
	$TracksParent/Tracks.add_child(track)

#var re: RegEx = RegEx.new()
func parse_m3u(path: String) -> int:
	#re.compile('#EXTINF:(\\d+?), (.*?) - (.*)$')
	var f = File.new() # File will only be read once
	f.open(path, File.READ)
	
	var line: String = f.get_line()
	if line != "#EXTM3U":
		return FAILED # not a valid file
		
	var dir = path.get_base_dir()
	while line != "":
		
		if not line.begins_with("#"):
			if line.is_abs_path():
				self.add_track(line)
			elif line.is_rel_path():
				self.add_track(dir+'/'+line)
		
		match line.substr(4,3):
			"INF":
				#var data = re.search(line).get_strings()
				#var length = data[1]
				#var creator = data[2]
				#var title = data[3]
				pass
			_:
				pass
		line = f.get_line()
		
	f.close()
	return OK

func add_from(dirn: String):
	var dir = Directory.new()
	dir.open(dirn)

	dir.list_dir_begin(true, true)
	var tracks = []
	var name = dir.get_next()
	while name != "":
		var ext = name.get_extension()
		
		if ext == 'flac' or ext == 'mp3' or ext == 'ogg':
			tracks.push_back(dirn + '/' + name)
		
		# if you find a playlist file, use it & reset
		if (ext == 'm3u' or ext == 'm3u8') and parse_m3u(dirn + '/' + name) == OK:
			tracks = []
			break
		
		name = dir.get_next()

	for track in tracks:
		add_track(track)

onready var title = $VBoxContainer/PanelContainer/Title
onready var tracks_n = $TracksParent/Tracks
const MaximumTracksInColumn = 7.0
#var closed_size = Vector2(150, 174)
#var open_size = Vector2(160, 174)
func _ready():
	var meta: TagFile = tracks_n.get_child(0).metadata
	var art = meta.get_album_art()
	var total_tracks = get_tracks_len()
	var columns = ceil(total_tracks / MaximumTracksInColumn)
	tracks_n.columns = columns if columns > 1 else 1
	
	if self.get_name() == "Unsorted":
		title.text = "Unsorted"
	else:
		title.text = meta.get_album()
		if art:
			$VBoxContainer/Art.texture.set_data(art)
	
	for i in range(0, total_tracks):
		var track = tracks_n.get_child(i)
		track.connect("pressed", Global.Player, "play_album", [ tracks_n, i, $VBoxContainer/Art.texture ])		

func _on_Album_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed == true and event.button_index == BUTTON_LEFT:
		var is_visible = $TracksParent.visible
		if not is_visible:
			$TracksParent.visible = true
		else:
			$TracksParent.visible = false
