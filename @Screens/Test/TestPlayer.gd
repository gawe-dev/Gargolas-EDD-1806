extends Node3D

var vida:int = 10

func GetDamage(damage:int):
	print("AH ", damage)
	vida -= damage
	if vida < 0 :
		name += "Down"
		$CollisionShape3D.disabled = true
		$MeshInstance3D.visible = false
