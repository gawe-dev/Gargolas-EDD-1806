extends Area3D

const RANGE :int = 20
const DAMAGE:int = 1
var shooted:bool = false

func _ready():
	connect("body_entered",hit_entered)
	

func _process(delta):
	if shooted:
		global_position.x += global_basis.z.x * 5 * delta
		global_position.y += global_basis.z.y * 5 * delta
		global_position.z += global_basis.z.z * 5 * delta
		


func shootBullet(target_position):
	initial()
	visible = true
	shooted = true
	look_at(target_position, Vector3.UP, true)

func initial():
		global_position = $"../..".global_position

func hit_entered(body:Node3D):
	if shooted and not body.is_in_group("Enemy"):
		if body.has_method("GetDamage"):
			body.GetDamage(DAMAGE)
		shooted = false
		visible = false
