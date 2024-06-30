extends Node3D

@onready var collision:CollisionShape3D = $CollisionShape3D

var vida:int = 10

func GetDamage(damage:int):
	print("AH ", damage)
	vida -= damage
	if vida < 0 :
		name += "Down"
		collision.set_deferred("disabled",true)
		$MeshInstance3D.visible = false
