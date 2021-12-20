extends Control

var config = ConfigFile.new()
var dir_item = preload("res://General/Settings/DirectoryItem.tscn")
var dialog_size: Vector2
var dirs: PoolStringArray = []
const config_path = "user://cello.cfg"
onready var items = $"Content/Search Directories/Items"
func _ready():
	config.load(config_path)
	print(ProjectSettings.globalize_path(config_path))
	#print(config)
	var music_dir: String = OS.get_system_dir(OS.SYSTEM_DIR_MUSIC)
	dirs = config.get_value("general", "search-dirs", [ music_dir ])
	var viewport: Vector2 = get_viewport().size
	dialog_size = Vector2(viewport[0] / 1.5, viewport[1] / 1.5)
	$FileDialog.current_dir = music_dir.get_base_dir()
	var i = 0
	print(dirs)
	for dir in dirs:
		var item = dir_item.instance()
		if dir == music_dir:
			item.unremovable = true
		item.directory = dir
		item.connect("tree_exited", self, "remove_i", [ i ])
		items.add_child(item)
		i+=1
	#items.print_tree_pretty()
	#print(items.rect_size)
	#print(items.rect_min_size)
	#print(items.get_parent().rect_size)
	#print(items.get_parent().rect_min_size)
	$"Content/User Interface/Row/HBoxContainer/Max Columns".value = config.get_value("ui", 'max-cols', 5)

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
	#print(dirs)
	config.save(config_path)


func _on_Max_Columns_value_changed(value):
	config.set_value("ui", "max-columns", value)
	config.save(config_path)
