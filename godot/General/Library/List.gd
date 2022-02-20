extends GridContainer
const Album = preload("res://General/Library/FullAlbum.tscn")
const AlbumT = preload("res://General/Library/FullAlbum.gd")
const Index = preload("res://General/Library/Index.gd")

const album_size := 150.0

func _ready():
	var all := Index.new().create_initial_index()
	for album in all:
		var n = Album.instance()
		for track in all[album]:
			
			if track.get_file() == "cover.jpg" or track.get_file() == "cover.png":
				n.art = ImageTexture.new()
				n.art_path = track
				var img = Image.new()
				img.load(track)
				n.art.create_from_image(img)
				continue
			
			n.add_track(track)
		if album in Index.special_album_names:
			n.title = album.capitalize()
		add_child(n)
	_on_List_resized()

func _on_List_resized():
	columns = floor(rect_size[0] / album_size) -1
