extends Node

var Config: ConfigFile = ConfigFile.new()
var AudioMetadata = preload("res://Assets/audio_metadata.gdns").new()
var MprisInterface = preload("res://Assets/mpris_interface.gdns").new()
var t: Thread
func _ready():
	if Config.load("user://cello.cfg") != null:
		Config.save("user://cello.cfg")
	# self.add_child(AudioMetadata)
	self.add_child(MprisInterface)
	MprisInterface.start_serving()
