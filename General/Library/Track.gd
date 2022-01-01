extends Button
class_name AlbumTrack

export var path: String #setget _, format_path
var zip_source: ZIPReader
var metadata := TagFile.new()

func _ready():
	if not zip_source:
		metadata.open_path(path)
	else:
		metadata.open_bytes(zip_source.read_file(path.split("::")[1]))
	self.hint_tooltip = metadata.get_title()
	#metadata.close()
