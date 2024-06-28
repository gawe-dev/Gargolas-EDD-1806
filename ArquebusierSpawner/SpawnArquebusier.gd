extends Node3D

@export var laneAttack:String = "Mid"

@onready var arquebusierScene : PackedScene = preload("res://Arquebusier/Arquebusier.tscn")

var arquebusierInstance: CharacterBody3D
func CreateUnit():
	arquebusierInstance = arquebusierScene.instantiate()
	arquebusierInstance.laneAttack = laneAttack
	add_child(arquebusierInstance)
