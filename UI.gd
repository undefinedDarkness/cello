extends Control

func _switch_tab(tab_no: int):
	$Tabs.current_tab = tab_no
	var i = 0
	for child in $"Sidebar/Contents/VBoxContainer/Tab Switcher".get_children():
		child.active = i == tab_no
		child.update()
		i+=1

func _ready():
	$Tabs/Playlist/MarginContainer/List.append_item("res://Assets/test.mp3")
	
	var i = 0
	for child in $"Sidebar/Contents/VBoxContainer/Tab Switcher".get_children():
		child.connect("pressed", self, "_switch_tab", [ i ])
		i+=1