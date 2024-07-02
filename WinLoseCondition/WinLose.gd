extends Area3D

var vida := 10

@onready var vidaLabel = $Control/Label
func _ready():
	vidaLabel.text = str(vida)

func _on_body_exited(body:Node3D):
	if body.is_in_group("Enemy"):
		vida -= 1
		body.GetDamage(1000)
		vidaLabel.text = str(vida)
		if vida <= 0:
			Global.lose = true


func _on_timer_timeout():
	print("Enemigos vivos ",Global.enemigos_vivos)
	if (Global.enemigos_vivos <= 0):
		Global.win = true
