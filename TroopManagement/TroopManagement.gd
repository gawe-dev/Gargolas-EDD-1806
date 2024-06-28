extends Node3D

@onready var timer:Timer = $Timer

var Wave0:Array[Node3D]
var Wave1:Array[Node3D]
var Wave2:Array[Node3D]

func _ready():
	timer.timeout.connect(CreateActiveWave)
	
	for node in find_child("Wave0",false).find_children("Spawn*", "Node3D"):
		Wave0.push_back(node)
		
	for node in find_child("Wave1",false).find_children("Spawn*", "Node3D"):
		Wave1.push_back(node)
		
	for node in find_child("Wave2",false).find_children("Spawn*", "Node3D"):
		Wave2.push_back(node)
	
	CreateActiveWave()


var WavesCount: int = 0
func CreateActiveWave():
	if WavesCount <= 5:
		for wave in Wave0:
			wave.CreateUnit()
	if WavesCount <= 10 and WavesCount >= 5:
		for wave in Wave1:
			wave.CreateUnit()
	if WavesCount <= 15 and WavesCount >= 10:
		for wave in Wave2:
			wave.CreateUnit()
	WavesCount += 1
