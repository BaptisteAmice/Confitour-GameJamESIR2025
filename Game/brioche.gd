extends Node3D
class_name Brioche

@onready var rigid_body_3d: RigidBody3D = $RigidBody3D

func change_gravity(gravity: float):
	rigid_body_3d.gravity_scale = gravity

func _ready():
	self.change_gravity(0)
