extends HBoxContainer

const Album = preload("res://General/Library/FullAlbum.gd")

export(NodePath) onready var Playlists = get_node(Playlists)
onready var tree: Tree = $Sidebar/Tree

export var edit_texture: Texture
func _ready():
	var root = tree.create_item()
	for album in Playlists.get_children():
		album = album as Album
		var item = tree.create_item(root)
		item.set_text(0, album.title)
		
		for track in album.get_tracks():
			var child = tree.create_item(item)
			child.set_text(0, track.hint_tooltip)
			child.set_tooltip(0, track.path)
			child.set_metadata(0, { album = track.album, length = track.length })
	
		if album.playlist_path:
			item.set_metadata(0, album.playlist_path)
			item.add_button(0, edit_texture, -1, false, "Edit Playlist")

onready var playlist_dir: String = Global.Config.get_value("general", "playlist-save-dir", OS.get_system_dir(OS.SYSTEM_DIR_MUSIC)+"/Playlists") 
onready var playlist_path = playlist_dir+'/'+$VBoxContainer/PanelContainer/Preview/Title.text+'.playlist.txt' 

func _on_Save_pressed():
	Directory.new().make_dir_recursive(playlist_path.get_base_dir())
	var f := File.new()
	f.open(playlist_path, File.WRITE)
	var item = $VBoxContainer/Main.get_root().get_children()
	while item != null:
		f.store_line((item as TreeItem).get_tooltip(0))
		item = item.get_next()
	f.close()

func _on_Title_text_changed(new_text):
	playlist_path = playlist_dir.plus_file(new_text+'.playlist.txt') 
