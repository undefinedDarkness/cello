extends Control

# export(PackedScene) onready var mini_player_layout = mini_player_layout.instance() # as Node

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



func _on_Player_mini_player_mode():
	OS.window_size = Vector2(500, 150)
	$Sidebar.visible = false
	$Tabs.visible = false
	$Miniplayer.visible = true
	OS.window_resizable = false
	# self.add_child(mini_player_layout)
