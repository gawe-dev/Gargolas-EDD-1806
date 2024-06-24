extends Node3D

@export var laneAttack:String = "Mid"

@onready var mosketeerScene : PackedScene = preload("res://Musketeer/Musketeer.tscn")

var mosketeerInstance: CharacterBody3D
func CreateUnit():
	mosketeerInstance = mosketeerScene.instantiate()
	mosketeerInstance.laneAttack = laneAttack
	add_child(mosketeerInstance)
