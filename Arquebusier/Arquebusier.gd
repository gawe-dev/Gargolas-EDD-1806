extends CharacterBody3D

@onready var climb_ray : RayCast3D = $LowBody/ClimbRay
@onready var high_body : Node3D = $HighBody
@onready var timer : Timer = $Timer
@onready var bullet : Node3D = $HighBody/MeshGun/NecessaryNode/Bullet
@onready var animation : AnimationPlayer = $LowBody/EnemigoInf/AnimationPlayer

var target:Node3D
var drops:Node
var flags:Array[Node3D]

var laneAttack:String # se setea desde spawner
var barricades:Array[Node3D]
var barricadeFinal:Node3D

func _ready():
	Global.enemigos_vivos += 1
	##Obtener todas las banderas del spawn de esta instancia
	for node in get_parent().find_children("Flag*", "Node3D",false):
		flags.push_back(node)
	
	##Obtener todas las barricadas de la linea sugerida por el spawn
	for node in get_tree().current_scene.find_child(laneAttack).get_children(false):
		barricades.push_back(node)
	
	##Obtener player para targetear
	target = get_tree().current_scene.get_node("%Player")
	drops = get_tree().current_scene.get_node("%Drops")
	barricadeFinal = get_tree().current_scene.get_node("%BarricadeFinal")
	
	##Conectar timer con callback
	timer.timeout.connect(ShootOrReload)

var delta : float
func _physics_process(_delta):
	delta = _delta
	ManageGravity()
	ManageForward()
	ManageDuty()
	ManageRoute()
	UpdateCurrentBarricade()
	SensorClimb()
	SensorPrepareAim()
	move_and_slide()

#region Management

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
func ManageGravity():
	if GravityState == GravityTypes.Falling:
		velocity.y -= gravity * delta
	if GravityState == GravityTypes.Climbing:
		velocity.y = 2
	if GravityState == GravityTypes.Infiltrating:
		GetDamage(10)
		climb_ray.get_collider().GetDamage(1)


var speed : float
enum ForwardTypes { Walk, Stop }
var ForwardMode : ForwardTypes = ForwardTypes.Walk
func ManageForward():
	velocity.x = global_basis.z.x * speed
	velocity.z = global_basis.z.z * speed
	if ForwardMode == ForwardTypes.Walk:
		speed = 1
		animation.play("Walk")
	if ForwardMode == ForwardTypes.Stop:
		speed = 0
		animation.play("Idle")


var reloading : bool = false
func ManageDuty():
	if target_in_range:
		high_body.look_at(target.global_position, Vector3.UP, true)
		if not reloading:
			AimAndShoot()
	elif barricade_in_range:
		if current_barricade < barricades.size():
			high_body.look_at(barricades[current_barricade].global_position, Vector3.UP, true)
		else:
			high_body.look_at(barricadeFinal.global_position, Vector3.UP, true)
		if not reloading:
			AimAndShoot()
	else:
		if high_body.rotation != Vector3.ZERO:
			high_body.rotation = Vector3.ZERO


var can_shoot := true
func AimAndShoot():
	if can_shoot:
		can_shoot = false
		timer.start()


var shoot_target:Vector3 = Vector3.ZERO
func ShootOrReload():
	if not reloading:
		bullet.shootBullet(shoot_target)
		can_shoot = false
		reloading = true
		timer.wait_time = 5
		timer.start()
	else:
		timer.wait_time = 5
		can_shoot = true
		reloading = false


var current_flag = 0
func ManageRoute():
	#si actual barricada no tiene propiedad destruida en true
	#si mi padre es cover
	if get_parent().name.contains("Cover"):
			#si estoy lejos de cover
			if (global_position - get_parent().global_position).length() > .5:
				look_at(get_parent().global_position, Vector3.UP,true)
				rotation.x = 0
				rotation.z = 0
			else:
				ForwardMode = ForwardTypes.Stop
#   si mi padre no es cover
	else:
		#si la bandera tiene hijos
		if flags[current_flag].find_children("Cover*").size() != 0:
			#recorrer cada hijo (cover)
			for cover in flags[current_flag].find_children("Cover*"):
				#si cover no tiene un hijo
				if cover.get_child_count() == 0:
					#emparentar esta instancia a cover
					reparent(cover)
			#si para este punto no tiene de padre a cover
			if not get_parent().name.contains("Cover"):
				NextFlagOrDie()
		else: #si la bandera no tiene hijos
			NextFlagOrDie()
			look_at(flags[current_flag].global_position, Vector3.UP,true)

func NextFlagOrDie():
	if (global_position - flags[current_flag].global_position).length() < 1:
		if current_flag + 1 < flags.size():
			current_flag += 1
		

#endregion


#region Sensores


var current_barricade := 0
func UpdateCurrentBarricade():
	
	if current_barricade < barricades.size():
		if barricade_in_range and barricades[current_barricade].name.contains("Down"):
			current_barricade += 1


enum GravityTypes { Falling, Climbing, Infiltrating }
var GravityState:GravityTypes
func SensorClimb():
	if climb_ray.is_colliding():
		if climb_ray.get_collider().is_in_group("Stair"):
			GravityState = GravityTypes.Climbing
		if climb_ray.get_collider().is_in_group("Barricade"):
			GravityState = GravityTypes.Infiltrating
	else:
		GravityState = GravityTypes.Falling


var target_in_range := false
var barricade_in_range := false
func SensorPrepareAim():
	
	target_in_range = (global_position - target.global_position).length() < (bullet.RANGE - 5)
	
	if target_in_range:
		shoot_target = target.global_position
	else:
		if current_barricade < barricades.size():
			shoot_target = barricades[current_barricade].global_position
			barricade_in_range = (global_position - barricades[current_barricade].global_position).length() < (bullet.RANGE -5)
		else:
			shoot_target = barricadeFinal.global_position
			barricade_in_range = (global_position - barricadeFinal.global_position).length() < (bullet.RANGE -5)
	


#endregion


#region Calleables

@onready var soundDeath:AudioStreamPlayer3D = $Death
var health := 1
func GetDamage(damage:int):
	health -= damage
	if health <= 0:
		soundDeath.reparent(get_tree().current_scene)
		soundDeath.play()
		soundDeath.connect("finished",soundDeath.queue_free)
		drops.createDrop(global_position)
		queue_free()
		Global.enemigos_vivos -= 1
	


#endregion



