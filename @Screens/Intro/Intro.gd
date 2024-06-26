extends Control

@onready var button:Button = $Button
@onready var videoplayer:VideoStreamPlayer = $VideoStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	button.connect("button_up", ChangeScene)
	videoplayer.connect("finished", ChangeScene)

func ChangeScene():
	get_tree().change_scene_to_file("res://@Screens/Menu/Menu.tscn")
