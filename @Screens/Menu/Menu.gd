extends Control

func _ready():
	Global.win = false
	Global.lose = false

func _on_play_button_up():
	get_tree().change_scene_to_file("res://@Screens/Lvl1Summary/Summary.tscn")

func _on_info_button_up():
	get_tree().change_scene_to_file("res://@Screens/Info/Info.tscn")

var busIndex
func _on_audio_button_up():
	busIndex = AudioServer.get_bus_index("Master")
	if AudioServer.is_bus_mute(busIndex):
		AudioServer.set_bus_mute(busIndex, false)
	else:
		AudioServer.set_bus_mute(busIndex, true)
