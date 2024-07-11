extends Node3D

@export var laneAttack:String = "Mid"

@onready var cannonScene : PackedScene = preload("res://Cannon/Cannon.tscn")

var cannonInstance: CharacterBody3D
func CreateUnit():
	cannonInstance = cannonScene.instantiate()
	cannonInstance.laneAttack = laneAttack
	add_child(cannonInstance)
