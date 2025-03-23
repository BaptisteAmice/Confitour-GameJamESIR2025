extends Brioche
class_name BriocheConfiture
@onready var jelly_fall: GPUParticles3D = $RigidBody3D/Jelly_fall
@onready var jelly_impact: GPUParticles3D = $RigidBody3D/Area3D/Jelly_Impact

@onready var area_3d: Area3D = $RigidBody3D/Area3D

func change_gravity(gravity: float):
	rigid_body_3d.gravity_scale = gravity

func _ready():
	self.change_gravity(0)


func _process(delta: float) -> void:
	if is_falling():
		jelly_fall.emitting= true
	else : 
		jelly_fall.emitting = false


func _on_area_3d_body_entered(body: Node3D) -> void:
	if (typeof(body)==24 and rigid_body_3d != body):
		jelly_impact.emitting = true
		print("Brioche")
