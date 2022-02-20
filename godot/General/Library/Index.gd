extends Reference

const special_album_names = [ "unsorted" ]


static func _sort(a: String, b: String):
	return a < b

func parse_m3u(path: String) -> Array:
	var f := File.new() # File will only be read once
	if f.open(path, File.READ) != null:
		printerr("Failed to open file, ", path)
		return []
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

	
func parse_playlist_file(path: String) -> PoolStringArray:
	var f := File.new()
	if f.open(path, File.READ) != null:
		printerr("Failed to open file, ", path)
		return [] as PoolStringArray
	var a: PoolStringArray = []
	var line := f.get_line()
	while line != "":
		if f.file_exists(line):
			a.push_back(line)
		line = f.get_line()
	f.close()
	return a

func new_album(dirn) -> PoolStringArray:
	var dir = Directory.new()
	dir.open(dirn)

	dir.list_dir_begin(true, true)
	var tracks  = []
	var name = dir.get_next()
	while name != "":
		name = dirn + '/' + name
		var ext = name.get_extension()
		if ext == 'flac' or ext == 'mp3' or ext == 'ogg':
			tracks.push_back( name )
		# if you find a index file, use it & reset
		elif (ext == 'm3u' or ext == 'm3u8'):
			tracks = parse_m3u(name)
			break
		elif name.ends_with('.playlist.txt'):
			tracks = parse_playlist_file(name)
			break
		elif name.get_file() == "cover.png" or name.get_file() == "cover.jpg":
			tracks.push_back(name)
		
		name = dir.get_next()
	tracks.sort_custom(self, "_sort")
	return tracks

func create_initial_index() -> Dictionary:
	var dirs: PoolStringArray = Global.Config.get_value("general", "search-dirs", [ OS.get_system_dir(OS.SYSTEM_DIR_MUSIC) ])
	var dir := Directory.new()
	var unsorted: PoolStringArray = []
	var complete_index := {}
	# unsorted.title = "Unsorted"
	for dirn in dirs:
		if dir.open(dirn) != OK:
			continue
		var _err = dir.list_dir_begin(true, true)
		var name = dir.get_next()
		while name != "":
			name = dirn + '/' + name
			var ext = name.get_extension()
			if dir.current_is_dir():
				complete_index[name] = new_album(name)
			elif ext == 'flac' or ext == 'mp3' or ext == 'ogg':
				print("Adding ", name, " to unsorted ")
				unsorted.push_back(name )
			elif ext == 'zip':
				pass
			elif name.ends_with('.playlist.txt'):
				complete_index[name] = parse_playlist_file(name)
			
			name = dir.get_next()
	complete_index["unsorted"] = unsorted
	return complete_index
	
