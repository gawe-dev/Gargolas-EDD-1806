extends Node3D

@onready var animation :AnimationPlayer = $AnimationPlayer

func Interact():
	if !animation.is_playing():
		animation.play("Shoot")


func _on_area_3d_body_entered(body):
	if body.has_method("GetDamage"):
		body.GetDamage(10)


func _on_area_3d_area_entered(area):
	if area.has_method("GetDamage"):
		area.GetDamage(10)
