extends Control

var config: ConfigFile = Global.Config
var dir_item = preload("res://General/Settings/DirectoryItem.tscn")
var dialog_size: Vector2
var dirs: PoolStringArray = []
onready var items = $"Content/Content/Search Directories/Items"

export(NodePath) onready var Visualizer = get_node(Visualizer) as Control
export(NodePath) onready var TabParent = get_node(TabParent) as TabContainer
export(NodePath) onready var Sidebar = get_node(Sidebar) as PanelContainer
func _ready():
	var music_dir: String = OS.get_system_dir(OS.SYSTEM_DIR_MUSIC)
	dirs = config.get_value("general", "search-dirs", [ music_dir ])
	var viewport: Vector2 = get_viewport().size
	dialog_size = Vector2(viewport[0] / 1.5, viewport[1] / 1.5)
	$Content/FileDialog.current_dir = music_dir.get_base_dir()
	var i = 0
	for dir in dirs:
		var item = dir_item.instance()
		if dir == music_dir:
			item.unremovable = true
		item.directory = dir
		item.connect("tree_exited", self, "remove_i", [ i ])
		items.add_child(item)
		i+=1
	
	var columns: int = config.get_value("visualizer", "columns", 16)
	$Content/Content/Visualizer/Row/HBoxContainer/Columns.value = columns
	Visualizer.VU_COUNT = columns
	
	var spacing: int = config.get_value("visualizer", "spacing", 8)
	$Content/Content/Visualizer/Row3/HBoxContainer/Spacing.value = spacing
	Visualizer.spacing = spacing
	
	var color := Color(config.get_value("visualizer", "color", "#fafafa") as String)
	$Content/Content/Visualizer/Row2/HBoxContainer/Color.color = color
	Visualizer.color = color
	
	var volume: float = config.get_value("general", "volume", 0)
	$Content/Content/Player/Row/Volume.value = abs(-80-volume)
	AudioServer.set_bus_volume_db(0, volume)
	
	var dir: String = config.get_value("general", "playlist-save-dir", music_dir+'/Playlists')
	$"Content/Content/Search Directories/HBoxContainer/HBoxContainer/PlaylistSaveDir".text = dir

func remove_i(index: int):
	if index >= dirs.size():
		return
	dirs.remove(index)

func _on_Add_New_pressed():
	$FileDialog.popup_centered(dialog_size)

func _on_FileDialog_dir_selected(dir: String):
	$FileDialog.hide()
	for d in dirs:
		if d == dir:
			return
	dirs.push_back(dir)
	var item = dir_item.instance()
	item.directory = dir
	item.connect("tree_exited", self, "remove_i", [ dirs.size()-1 ])
	items.add_child(item)

func _on_Save_pressed():
	config.set_value("general", "search-dirs", dirs)
	config.save("user://cello.cfg")


func _on_Max_Columns_value_changed(value):
	config.set_value("visualizer", "columns", value)
	config.save("user://cello.cfg")
	Visualizer.VU_COUNT = value
	Visualizer._on_Control_resized()

export var Playlists: NodePath
func _on_Force_Reload_pressed():
	var n = get_node(Playlists)
	for c in n.get_children():
		c.queue_free()
	n._ready()


func _on_Spacing_value_changed(value):
	config.set_value("visualizer", "spacing", value)
	config.save("user://cello.cfg")
	Visualizer.spacing = value
	Visualizer._on_Control_resized()


func _on_Color_color_changed(color: Color):
	config.set_value("visualizer", "color", "#"+color.to_html())
	config.save("user://cello.cfg")
	Visualizer.color = color

# value is a number between 0 and 80
func _on_Volume_value_changed(value: int):
	value = -80 + value
	config.set_value("general", "volume", value)
	config.save("user://cello.cfg")
	AudioServer.set_bus_volume_db(0, value)


func _on_Button2_pressed():
	var creator = load("res://General/MixtapeCreator/MixtapeCreator.tscn").instance()
	creator.Playlists = Playlists
	Sidebar.visible = false
	TabParent.add_child(creator)
	TabParent.current_tab = 3


func _on_PlaylistSaveDir_text_entered(new_text):
	config.set_value("general", "playlist-save-dir", new_text)
	config.save("user://cello.cfg")
