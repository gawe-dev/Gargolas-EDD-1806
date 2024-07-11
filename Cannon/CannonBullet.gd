extends Area3D


const RANGE  : int = 15
const DAMAGE : int = 3
var velocity : int = 0
var shooted : bool = false


func _ready():
	connect("body_entered",hit_entered)
	


func _process(delta):
	if shooted:
		global_position.x += global_basis.z.x * velocity * delta
		global_position.y += global_basis.z.y * velocity * delta
		global_position.z += global_basis.z.z * velocity * delta
	if (initial_position - global_position).length() > RANGE:
		desactivar()


func activar():
	velocity = 20
	visible = true
	shooted = true
	set_deferred("monitoring", true)

func desactivar():
	velocity = 0
	shooted = false
	visible = false
	set_deferred("monitoring", false)


func shootBullet(target_position):
	initial()
	look_at(target_position, Vector3.UP, true)
	activar()
	$ShootSound.play()


var initial_position : Vector3
func initial():
	initial_position = $"../..".global_position
	global_position = initial_position


func hit_entered(body:Node3D):
	if shooted and not body.is_in_group("Enemy"):
		if body.has_method("GetDamage"):
			body.GetDamage(DAMAGE)
		desactivar()

