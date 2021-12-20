extends GridContainer
var config = ConfigFile.new()
var playlist_item = preload("res://General/Playlist/PlaylistItem.tscn")

export var player_p: NodePath
onready var player = get_node(player_p)
#onready var layout = self
func append_item(f: String):
	#print(f)
	var item = playlist_item.instance()
	item.file = f
	item.connect("play_now", player, "load_file")
	self.add_child(item)

# TODO:
# Show items in ordered albums (grid layout)
# Fix grid scrolling / selecting issue
# Add search if possible
# Sort in album order 
# Read .m3u files
# Show run length
var child_size: float
var max_cols: int
func _ready():
	config.load("user://cello.cfg")
	var dirs: PoolStringArray = config.get_value("general", "search-dirs", [ OS.get_system_dir(OS.SYSTEM_DIR_MUSIC) ])
	var dir: Directory = Directory.new()
	for dirn in dirs:
		dir.open(dirn)
		dir.list_dir_begin(true, true)
		while true:
			var file: String = dir.get_next()
			if file == "":
				break
			var ext = file.get_extension()
			if ext == "mp3" or ext == "flac" or ext == "ogg":
				append_item(dirn + "/" + file)
		dir.list_dir_end()
	child_size = self.get_child(0).rect_size[0] + 32
	max_cols = config.get_value('ui', 'max-cols', 5)
	self._on_List_resized()

# This does not deal with reducing screen size
func _on_List_resized():
	var parent_size = self.rect_size[0]
	var c = floor(floor(parent_size / child_size) / 2)
	# Deal with my terrible math code
	#if c == self.columns:
	#	return
	#else:
	self.columns = c
