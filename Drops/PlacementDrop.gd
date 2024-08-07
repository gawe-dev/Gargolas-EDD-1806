extends Node

@onready var dropMusketScene : PackedScene = preload("res://Drops/DropMusket.tscn")
@onready var dropArquebusScene : PackedScene = preload("res://Drops/DropArquebus.tscn")
@onready var dropMate : PackedScene = preload("res://Drops/DropMate.tscn")

var rng := RandomNumberGenerator.new()
var rngi:int
var newDrop:Node3D
func createDrop(global_position:Vector3):
	rngi = rng.randi_range(1,4)
	
	if rngi == 1:
		newDrop = dropMusketScene.instantiate()
		add_child(newDrop)
		newDrop.name = "DropMusket"
		print(newDrop.name)
		newDrop.global_position = global_position
	if rngi == 2:
		newDrop = dropArquebusScene.instantiate()
		add_child(newDrop)
		newDrop.name = "DropArquebus"
		newDrop.global_position = global_position
	if rngi == 3:
		newDrop = dropMate.instantiate()
		add_child(newDrop)
		newDrop.name = "DropMate"
		newDrop.global_position = global_position
