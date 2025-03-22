extends Node3D
class_name Brioche

@onready var rigid_body_3d: RigidBody3D = $RigidBody3D
@export var collision_disabled: bool = false
@onready var collision_shape_3d: CollisionShape3D = $RigidBody3D/CollisionShape3D	

# Threshold value for detecting if the object is falling
@export var fall_threshold: float = -1.0

@onready var accounted_in_scoring = false

func to_account_in_scoring() -> bool:
	return self.accounted_in_scoring and not self.is_falling()
	
func scale_brioche(factor: float):
	rigid_body_3d.scale = rigid_body_3d.scale * factor
	
	

func is_falling() -> bool:
	# Return true if the velocity on the Y-axis is less than the fall threshold (falling down)
	return rigid_body_3d.linear_velocity.y < fall_threshold
	
func _on_wait_before_scoring_timeout() -> void:
	self.accounted_in_scoring = true
	

func change_gravity(gravity: float):
	rigid_body_3d.gravity_scale = gravity

func _ready():
	self.change_gravity(0)
	collision_shape_3d.disabled = collision_disabled
	
func _physics_process(delta: float) -> void:
	if rigid_body_3d.gravity_scale>0:
		#print(self.rigid_body_3d.transform.origin.y)
		pass
