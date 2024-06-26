extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("button_up",ChangeScene)

func ChangeScene():
	get_tree().change_scene_to_file("res://@Screens/Test/Test.tscn")
