extends PanelContainer

signal play_now(f)
export var file: String

func _ready():
	var tag_f = TagFile.new()
	tag_f.open_path(file)
	#self.text = tag_f.get_title() + "\n" +tag_f.get_artist()
	$Content/MarginContainer/VBoxContainer/Title.text = tag_f.get_title()
	$Content/MarginContainer/VBoxContainer/Artist.text = tag_f.get_artist()
	var img = tag_f.get_album_art()
	if img:
		var texture: ImageTexture = ImageTexture.new()
		texture.create_from_image(img)
		#self.icon = texture
		$Content/Art.texture = texture
		$Content/Art.rect_min_size = Vector2(100, 100)

func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed == true and event.button_index == BUTTON_LEFT:
		#print(event)
		emit_signal("play_now", self.file)
