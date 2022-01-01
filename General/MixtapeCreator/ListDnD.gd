extends Tree

export(NodePath) onready var Title = get_node(Title) as LineEdit
export(NodePath) onready var Runtime = get_node(Runtime) as Label

func can_drop_data(_position, data):
	return data is TreeItem

func update_runtime():
	#print(total_runtime)
	var minutes = total_runtime/60.0
	Runtime.text = "Runtime: %.0fm%.0fs" % [ minutes, (minutes-int(minutes))*10 ]

onready var root = create_item()
#var total_items = 0
var total_runtime = 0
func drop_data(_position, data: TreeItem):
	#total_items += 1
	var i := create_item(root)
	#i.set_text(0, String(total_items))
	i.set_tooltip(0, data.get_tooltip(0))
	i.set_text(0, data.get_text(0))
	var metadata: TagFile = data.get_metadata(0)
	i.set_text(1, metadata.get_album())
	i.set_metadata(0, data.get_tooltip(0))
	total_runtime += metadata.get_length_in_seconds()
	update_runtime()

func _ready():
	Title.text = "New Album %x" % randi()
	
