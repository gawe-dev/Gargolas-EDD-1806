extends CharacterBody3D

signal SignalHealth

@onready var twist_pivot : Node3D = $TwistPivot
@onready var pitch_pivot : Node3D = $TwistPivot/PitchPivot

@onready var rayHook : RayCast3D = $TwistPivot/PitchPivot/Camera3D/RayCast3D
@onready var interactRay : RayCast3D = $MeshInstance3D/InteractRay
@onready var camera : Camera3D = $TwistPivot/PitchPivot/Camera3D

@onready var model : Node3D = $MeshInstance3D
@onready var animation_tree : AnimationTree = $MeshInstance3D/AnimationTree

func _ready():
	emit_signal("SignalHealth",health)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

var delta:float

func _physics_process(_delta):
	delta = _delta
	InputHideMouse()
	update_tree()
	handle_animations()
	if Global.win:
		camera.position = lerp(camera.position,Vector3(0,2,6),.1)
		VICTORIA()
		return
	elif health <= 0 or Global.lose:
		camera.position = lerp(camera.position,Vector3(0,2,6),.1)
		DERROTA()
		return
	
	GravityManagement()
	
	RotateCamara()
	
	InputJump()
	InputMovement()
	InputHook()
	
	InputCameraMode()
	
	GetDrops()
	move_and_slide()


#region Gravedad
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity_state : String = "Falling"
var hook_position : Vector3
func GravityManagement():
	
	
	if gravity_state == "Falling":
		velocity.y -= gravity * delta
		anim_actual = FALL
	
	
	if gravity_state == "Hooking":
		anim_actual = HOOK
		global_position = global_position.move_toward(hook_position,.2)
		if (global_position - hook_position).length() < .095:
			gravity_state = "Falling"
	
	if is_on_floor():
		anim_actual = IDLE
	


#endregion


#region Salto


var jump_velocity := 5
func InputJump():
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = jump_velocity
		
		if gravity_state == "Hooking":
			gravity_state = "Falling"
			velocity.y = jump_velocity * 1.8


#endregion


#region Input del hook

@onready var gancho:Node3D = $FreeGancho/Hook
func InputHook():
	if Input.is_action_just_pressed("hook"):
		if rayHook.is_colliding():
			gravity_state = "Hooking"
			hook_position = rayHook.get_collision_point()
			gancho.global_position = global_position
			gancho.look_at(hook_position,Vector3.UP,true)
			gancho.global_position = hook_position
		else:
			gravity_state = "Falling"


#endregion


#region Input del movimiento


var input_dir : Vector2
var direction : Vector3
var speed := 5.0
func InputMovement():
	input_dir = Input.get_vector("left", "right", "forward", "back")
	direction = (twist_pivot.basis * transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		if is_on_floor():
			anim_actual = RUN
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)


#endregion


#region Ocultar desocultar puntero
func InputHideMouse():
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
#endregion


#region CameraFunctions
var mouse_sensitivity := 0.001
var twist_input := 0.001
var pitch_input := 0.001
func RotateCamara():
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, -1, .7)
	
	twist_input = 0.0
	pitch_input = 0.0


func _unhandled_input(event: InputEvent) -> void :
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensitivity
			pitch_input = - event.relative.y * mouse_sensitivity


var apuntando:bool
func InputCameraMode():
	apuntando = Input.is_action_pressed("zoom")
	
	if not apuntando:
		if input_dir != Vector2.ZERO:
			model.rotation.y = lerp_angle(model.rotation.y,atan2(-direction.x,-direction.z),.3)
			
		if camera.position.z < 4.9:
			speed = 5.0
			camera.position = lerp(camera.position,Vector3(0,2,5),.1)
	
	if apuntando and is_on_floor():
		
		anim_actual = AIM
		model.rotation.y = lerp_angle(model.rotation.y,twist_pivot.rotation.y,.3)
		if camera.position.z > 1.7:
			speed = 2.0
			camera.position = lerp(camera.position,Vector3(1,1,1),.1)
		
#endregion

#region Recibir daño

var health := 25
func GetDamage(damage:int):
	health -= damage
	if health <= 0:
		gravity_state = "Falling"
		#dropear
		
	emit_signal("SignalHealth",health)

#endregion

#region Obtener drops del suelo

func GetDrops():
	if interactRay.is_colliding():
		if interactRay.get_collider().name.contains("DropMusket"):
			$MeshInstance3D/WeaponsManager.AddAmmo("GunMusket")
			interactRay.get_collider().queue_free()
		if interactRay.get_collider().name.contains("DropArquebus"):
			$MeshInstance3D/WeaponsManager.AddAmmo("GunArquebus")
			interactRay.get_collider().queue_free()
		if interactRay.get_collider().name.contains("DropMate"):
			interactRay.get_collider().queue_free()
			if health <= 25:
				health += 5
			else:
				health = 25
			emit_signal("SignalHealth",health)
			return
	
	if interactRay.is_colliding() and interactRay.get_collider().has_method("Interact"):
		$InteractF.visible = true
		if Input.is_key_pressed(KEY_F):
			interactRay.get_collider().Interact()
	else:
		$InteractF.visible = false

#endregion

#region Animaciones

enum {IDLE, RUN, HOOK, AIM, FALL, DEATH}
var anim_actual := IDLE
var blend_speed := 15

var Movement := 0.0
var States := 0.0
var FallHook := 0.0
func update_tree():
	animation_tree["parameters/Movement/blend_amount"] = Movement
	animation_tree["parameters/States/blend_amount"] = States
	animation_tree["parameters/FallHook/blend_amount"] = FallHook

func handle_animations():
	match anim_actual:
		RUN:
			Movement = lerpf(Movement,-1,blend_speed*delta)
			States = lerpf(States,0,blend_speed*delta)
		IDLE:
			Movement = lerpf(Movement,0,blend_speed*delta)
			States = lerpf(States,0,blend_speed*delta)
		AIM:
			Movement = lerpf(Movement,1,blend_speed*delta)
			States = lerpf(States,0,blend_speed*delta)
		DEATH:
			FallHook = lerpf(FallHook,-1,blend_speed*delta)
			States = lerpf(States,1,blend_speed*delta)
		FALL:
			FallHook = lerpf(FallHook,0,blend_speed*delta)
			States = lerpf(States,1,blend_speed*delta)
		HOOK:
			FallHook = lerpf(FallHook,1,blend_speed*delta)
			States = lerpf(States,1,blend_speed*delta)
	
#endregion

func DERROTA():
	anim_actual = DEATH
	$CanvasLayer.visible = false
	if not $ResetMenu/ColorRect/Win.visible:
		$ResetMenu.visible = true
		$ResetMenu/ColorRect/Lose.visible = true

func VICTORIA():
	anim_actual = IDLE
	$CanvasLayer.visible = false
	if not $ResetMenu/ColorRect/Lose.visible:
		$ResetMenu.visible = true
		$ResetMenu/ColorRect/Win.visible = true

