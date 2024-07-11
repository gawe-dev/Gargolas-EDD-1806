extends Node

@onready var troop:Node3D = $"../TroopManagement4"

func _process(delta):
	if find_children("*Down").size() > 0:
		troop.position.y = .5
		troop.process_mode = Node.PROCESS_MODE_INHERIT
