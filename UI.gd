extends Control

func _switch_tab(tab_no: int):
	$Tabs.current_tab = tab_no
	var i = 0
	for child in $"Sidebar/Contents/VBoxContainer/Tab Switcher".get_children():
		child.active = i == tab_no
		child.update_icon()
		i+=1

func _ready():
	var i = 0
	for child in $"Sidebar/Contents/VBoxContainer/Tab Switcher".get_children():
		child.connect("pressed", self, "_switch_tab", [ i ])
		i+=1

