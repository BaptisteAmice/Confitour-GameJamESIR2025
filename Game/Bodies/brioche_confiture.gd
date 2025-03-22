extends Brioche
class_name BriocheConfiture

@onready var area_3d: Area3D = $Area3D

func change_gravity(gravity: float):
	rigid_body_3d.gravity_scale = gravity

func _ready():
	self.change_gravity(0)
