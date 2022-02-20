tool
extends Button

export var active: bool

func update_icon():
	if active:
		text = ''
	else:
		text = ''

func _ready():
	update_icon()
