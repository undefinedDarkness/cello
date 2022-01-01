extends Node
var Player
var Config := ConfigFile.new()

func _ready():
	Config.load("user://cello.cfg")
