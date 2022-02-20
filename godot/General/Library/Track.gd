extends Button
class_name AlbumTrack

var title: String
var artist: String
var art: ImageTexture

var album: String
var length: float
var path: String

# const FullAlbum = preload("res://General/Library/FullAlbum.gd")

func _ready():
	var t = Global.AudioMetadata.get_textual_metadata(path)
	artist = t["artist"]
	title = t["title"] 
	album = t["album"] 
	hint_tooltip =t["title"] 
	
func get_art() -> Image:
	var img = Global.AudioMetadata.get_album_art(path)
	if img and not art:
		art = ImageTexture.new()
		art.create_from_image(img)
	return img
		
func _get_mpris_metadata() -> Dictionary:
	var art_path: String = get_parent().get_parent().get_parent().art_path
	if not art_path:
		art_path = ProjectSettings.globalize_path("res://Assets/album-default.jpg")
	if Directory.new().copy(art_path, "/tmp/cello-art."+art_path.get_extension()) != null:
		printerr("Failed to copy art for mpris from ", art_path, " to /tmp/cello-art*, maybe a permissions error???")
	return {
		title = title,
		album = album,
		artist = artist,
		length = length * 1e+6,
		art = "file:///tmp/cello-art."+art_path.get_extension()
	}
