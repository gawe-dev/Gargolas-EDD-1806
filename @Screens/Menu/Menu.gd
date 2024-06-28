extends Control

func _on_play_button_up():
	get_tree().change_scene_to_file("res://@Screens/Lvl1Summary/Summary.tscn")


func _on_options_button_up():
	get_tree().change_scene_to_file("res://@Screens/Galery/Galery.tscn")
