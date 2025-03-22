extends Node3D
class_name Brioche

@onready var rigid_body_3d: RigidBody3D = $RigidBody3D
@export var collision_disabled: bool = false
@onready var collision_shape_3d: CollisionShape3D = $RigidBody3D/CollisionShape3D
@onready var is_fallen: bool
	

func change_gravity(gravity: float):
	rigid_body_3d.gravity_scale = gravity

func _ready():
	self.change_gravity(0)
	collision_shape_3d.disabled = collision_disabled
