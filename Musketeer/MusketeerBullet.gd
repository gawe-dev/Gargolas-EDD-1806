extends Area3D

const RANGE :int = 20
const DAMAGE:int = 1
var shooted:bool = false

func _ready():
	connect("body_entered",hit_entered)

func _process(delta):
	if shooted:
		global_position.x += global_basis.z.x * 15 * delta
		global_position.y += global_basis.z.y * 15 * delta
		global_position.z += global_basis.z.z * 15 * delta
	if (Vector3.ZERO - position).length() > RANGE:
		initial()


func shootBullet():
	shooted = true

func initial():
		shooted = false
		position = Vector3.ZERO

func hit_entered(body:Node3D):
	if shooted and not body.is_in_group("Enemy"):
		initial()
		if body.has_method("GetDamage"):
			body.GetDamage(DAMAGE)
	
