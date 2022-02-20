extends Tree

func get_drag_data(_position): 
	set_drop_mode_flags(DROP_MODE_DISABLED)

	var selected: TreeItem = get_selected()

	if not selected.get_tooltip(0).length() > 0:
		return

	var preview = Label.new()
	preview.text = selected.get_text(0)
	set_drag_preview(preview)

	return selected

func can_drop_data(_position, _data):
	return false

export(NodePath) onready var Root = get_node(Root) as Node
export(NodePath) onready var MainTree = get_node(MainTree) as Node
func _on_Tree_button_pressed(item: TreeItem, column: int, id: int):
	var playlist_path: String = item.get_metadata(0)
	Root.get_node("VBoxContainer/PanelContainer/Preview/Title").text = playlist_path.get_file().replace(".playlist.txt", "")
	#print(Root)
	Root.playlist_path = playlist_path
	MainTree.clear()
	var child: TreeItem = item.get_children()
	while child != null:
		MainTree.drop_data(null, child)
		child = child.get_next()
