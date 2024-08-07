extends Resource

class_name Weapon_Resource

@export var Weapon_Name: String
@export var Activate_Anim: String
@export var Shoot_Anim: String
@export var Reload_Anim: String
@export var Deactivate_Anim: String

@export var Current_Ammo: int
@export var Reserve_Ammo: int
@export var Magazine: int
@export var Max_Ammo: int

@export var Auto_Fire: bool
@export_flags("HitScan", "Projectile", "Mele") var Type
@export var Weapon_Range : int
@export var Damage : int
