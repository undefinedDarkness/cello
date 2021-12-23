extends GridContainer
var Album =  preload("res://General/Playlist/Album.tscn")

func new_album(path):
	var album = Album.instance()
	album.add_from(path)
	self.add_child(album)

#var config = ConfigFile.new()
var ts = []
func _ready() -> void:
	#config.load("user://cello.cfg")
	var dirs: PoolStringArray = Global.Config.get_value("general", "search-dirs", [ OS.get_system_dir(OS.SYSTEM_DIR_MUSIC) ])
	var dir: Directory = Directory.new()
	var unsorted  = Album.instance()
	unsorted.name = "Unsorted"
	#unsorted.player = get_node(Player)
	for dirn in dirs:
		if dir.open(dirn) != OK:
			continue
		var _err = dir.list_dir_begin(true, true)
		var name = dir.get_next()
		while name != "":
			var ext = name.get_extension()
			if dir.current_is_dir():
				var t = Thread.new()
				t.start(self, "new_album", dirn + '/' + name)
				ts.push_back(t)
			elif ext == 'flac' or ext == 'mp3' or ext == 'ogg':
				unsorted.add_track(dirn + '/' + name)
			
			name = dir.get_next()
	if unsorted.get_tracks_len() > 1:
		#unsorted.add_track("res://Assets/test.mp3")
		self.add_child(unsorted)
		
	self.columns = ceil(rect_size[0] / unsorted.rect_size[0])

func _exit_tree():
	for t in ts:
		t.wait_to_finish()
