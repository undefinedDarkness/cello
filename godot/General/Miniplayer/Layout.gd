extends PanelContainer
const FullAlbum = preload("res://General/Library/FullAlbum.gd")
const AlbumTrack = preload("res://General/Library/Track.gd")

func update_ui(path: String, title: String, artist: String, art: ImageTexture, length: float):
	$HBoxContainer/TextureRect.texture = art
	$HBoxContainer/TextureRect.hint_tooltip = title + " ~ " + artist

export(NodePath) onready var listing = get_node(listing) as GridContainer

func _ready() -> void:
	Playback.connect("track_changed", self, "update_ui")
	
	var t = $HBoxContainer/Tree
	var root := t.create_item() as TreeItem
	for album in listing.get_children():
		var item := t.create_item(root) as TreeItem
		item.set_text(0, (album as FullAlbum).title)
		item.set_metadata(0, album)
		var index := 0
		for track in (album as FullAlbum).get_tracks():
			var label = t.create_item(item)
			label.set_text(0, (track as AlbumTrack).title)
			label.set_metadata(0, index)
			index += 1
			# label.set_button(0, )


func _on_Tree_gui_input(event: InputEvent) -> void:
	if event.is_pressed():
		var item := $HBoxContainer/Tree.get_selected() as TreeItem
		if not item:
			return
		var index = item.get_metadata(0)
		if index is int:
			Playback.queue_append_album(item.get_parent().get_metadata(0).get_tracks(), index)
		# elif index is FullAlbum:
		#	Playback.queue_append_album(index.get_tracks(), 0)
