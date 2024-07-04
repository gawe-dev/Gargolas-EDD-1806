extends StaticBody3D


var vida:= 1
var damage := 20
func GetDamage(_damage:int):
	vida -= _damage
	if vida <= 0:
		$AnimationPlayer.play("Explode")


func _on_animation_player_animation_finished(anim_name):
	queue_free()


func _on_area_3d_body_entered(body:Node3D):
	if body.has_method("GetDamage"):
		body.GetDamage(damage)
