extends HBoxContainer

export var directory: String
export var unremovable: bool

func _ready():
	$Name.text = directory
	if unremovable:
		$HBoxContainer/Remove.queue_free()

func _on_Button_pressed():
	queue_free()
