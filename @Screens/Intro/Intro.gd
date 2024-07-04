extends Control

func ChangeScene():
	get_tree().change_scene_to_file("res://@Screens/Menu/Menu.tscn")


func _on_button_button_up():
	ChangeScene()


func _on_video_stream_player_finished():
	ChangeScene()
