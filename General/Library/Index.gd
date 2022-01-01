extends GridContainer
const Album = preload("res://General/Library/Album.tscn")

# TODO: Replace the _zip methods
# TODO: Make functions zip path aware

func parse_m3u(path: String) -> Array:
	var f := File.new() # File will only be read once
	f.open(path, File.READ)
	var tracks := []
	var line := f.get_line()
	if line != "#EXTM3U":
		return tracks # not a valid file
		
	var dir = path.get_base_dir()
	while line != "":
		
		if not line.begins_with("#"):
			if line.is_abs_path() and f.file_exists(line):
				tracks.push_back(line)
			elif line.is_rel_path() and f.file_exists(dir+'/'+line):
				tracks.push_back(dir+'/'+line)
		line = f.get_line()
		
	f.close()
	return tracks
func parse_m3u_zip(source: ZIPReader, path: String, zip_path: String) -> Array:
	var content = source.read_file(path).get_string_from_utf8().split('\n', false)
	var tracks := []
	if content[0] != "#EXTM3U":
		return tracks
		
	# TODO: Check that file exists
	for line in content:
		if not line.begins_with("#"):
			tracks.push_back([zip_path+"::"+line, source])
		
	return tracks
	
func parse_playlist_file(path: String):
	var f := File.new()
	f.open(path, File.READ)
	var a: Album = Album.instance()
	a.playlist_path = path
	var line := f.get_line()
	while line != "":
		if f.file_exists(line):
			a.add_track(line)
		line = f.get_line()
	f.close()
	a.title = path.get_file().replace(".playlist.txt", "")
	add_child(a)

func new_album(dirn):
	var dir = Directory.new()
	dir.open(dirn)

	dir.list_dir_begin(true, true)
	var tracks: PoolStringArray = []
	var name = dir.get_next()
	while name != "":
		name = dirn + '/' + name
		var ext = name.get_extension()
		if ext == 'flac' or ext == 'mp3' or ext == 'ogg':
			tracks.push_back(name)
		# if you find a index file, use it & reset
		elif (ext == 'm3u' or ext == 'm3u8'):
			tracks = parse_m3u(name)
			break
		elif name.ends_with('.playlist.txt'):
			parse_playlist_file(name)
			return
		
		name = dir.get_next()

	if tracks.size() > 0:
		var a: Album = Album.instance()
		for track in tracks:
			a.add_track(track)
		self.add_child(a)

func new_album_from_zip(path: String):
	var reader: ZIPReader = ZIPReader.new()
	reader.open(path)
	
	var tracks = []
	for file in reader.get_files():
		var ext = file.get_extension()
		if ext == 'flac' or ext == 'ogg' or ext == 'mp3':
			tracks.push_back(file)
		elif (ext == 'm3u8' or ext == 'm3u'):
			tracks = parse_m3u_zip(reader, file, path)
			break
	if tracks.size() > 0:
		var a: Album = Album.instance()
		for track in tracks:
			a.add_track(track[0], track[1])
		self.add_child(a)

var ts := []
var album_size: int
func _ready() -> void:
	var dirs: PoolStringArray = Global.Config.get_value("general", "search-dirs", [ OS.get_system_dir(OS.SYSTEM_DIR_MUSIC) ])
	var dir := Directory.new()
	var unsorted: Album = Album.instance()
	album_size = unsorted.rect_size[0]
	unsorted.title = "Unsorted"
	for dirn in dirs:
		if dir.open(dirn) != OK:
			continue
		var _err = dir.list_dir_begin(true, true)
		var name = dir.get_next()
		while name != "":
			name = dirn + '/' + name
			var ext = name.get_extension()
			if dir.current_is_dir():
				var t = Thread.new()
				t.start(self, "new_album", name)
				ts.push_back(t)
			elif ext == 'flac' or ext == 'mp3' or ext == 'ogg':
				unsorted.add_track(name)
			elif ext == 'zip':
				var t = Thread.new()
				t.start(self, "new_album_from_zip", name)
				ts.push_back(t)
			elif name.ends_with('.playlist.txt'):
				parse_playlist_file(name)
				#var t = Thread.new()
				#t.start(self, "parse_playlist_file", name)
			
			name = dir.get_next()
	if unsorted.tracks_len > 1:
		self.add_child(unsorted)
	
	_resized()

export(NodePath) onready var size_n = get_node(size_n) as Node
func _resized():
	columns = floor(size_n.rect_size[0] / album_size)

func _exit_tree():
	for t in ts:
		t.wait_to_finish()
