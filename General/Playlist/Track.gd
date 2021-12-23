extends Button
class_name AlbumTrack

export var path: String
#var player
var metadata: TagFile = TagFile.new()

func _ready():
	metadata.open_path(path)
	self.hint_tooltip = metadata.get_title()
	#metadata.close()
