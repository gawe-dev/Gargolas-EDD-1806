extends Control

@onready var infoImage:Button = $InfoHideButton

func _ready():
	Global.win = false
	Global.lose = false

func _on_play_button_up():
	get_tree().change_scene_to_file("res://@Screens/Lvl2Summary/Summary.tscn")

func _on_info_button_up():
	infoImage.visible = true

func _on_info_hide_button_button_up():
	infoImage.visible = false

var busIndex := 0
func _on_audio_button_up():
	busIndex = AudioServer.get_bus_index("Music")
	if AudioServer.is_bus_mute(busIndex):
		AudioServer.set_bus_mute(busIndex, false)
	else:
		AudioServer.set_bus_mute(busIndex, true)



