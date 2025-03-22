extends Node3D
const BRIOCHE = preload("res://Game/Brioche.tscn")
var spawn_timer : Timer
@onready var background: Node3D = $".."

# Valeur fixe pour Z
var fixed_z = 1.0

	
# Fonction pour spawner un ennemi à une position aléatoire (X, Y) et Z fixe
func spawn_enemy():
	var enemy_instance = BRIOCHE.instantiate()
	# X et Y sont aléatoires, Z est fixe à 50
	enemy_instance.transform.origin = Vector3(randf_range(-2,2 ), fixed_z, randf_range(-2, 2))
	enemy_instance.collision_disabled = false
	background.add_child(enemy_instance)
	enemy_instance.change_gravity(1)


func _on_timer_timeout() -> void:
	spawn_enemy()
	
	
