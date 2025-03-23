extends Path3D
class_name ItemPath3D

@onready var path_follow_3d: PathFollow3D = $PathFollow3D
@export var progress_speed: float = 2  # Speed of the path following, adjusted based on delta time
@onready var player: Player = $".."
@onready var chute: AudioStreamPlayer = $"../AudioController/Chute"

@onready var rotation_poele = 0
@onready var anim_switch = true
@onready var play_anim = false
@onready var poele: Node3D = $PathFollow3D/Poele


const BRIOCHE = preload("res://Game/Brioche.tscn")
const BRIOCHE_CONFITURE = preload("res://Game/Bodies/Brioche_confiture.tscn")

func _physics_process(delta: float) -> void:
	# Update progress based on delta time to ensure consistent movement regardless of frame rate
	path_follow_3d.progress += progress_speed * delta
	poele_anim()
	
# Get the current spawner (the first child of path_follow_3d)
func get_current_spawner() -> Brioche:
	var path_follow = $PathFollow3D  # Assuming PathFollow3D is a child of the current node
	if path_follow.get_child_count() > 1:
		return path_follow.get_child(1)  # Return the first child
	return null  # Return null if there are no children
	
# Change the current spawner by replacing the child of path_follow_3d with a new brioche
func change_current_spawner(new_brioche: Brioche):
	var path_follow = $PathFollow3D  # Assuming PathFollow3D is a child of the current node
	
	# Remove all current children from path_follow_3d
	path_follow.get_children()[1].queue_free()
	
	# Add new_brioche as a child to path_follow_3d
	path_follow.add_child(new_brioche)
	#new_brioche.collision_shape_3d.position.y += 100

	
func instantiate_brioche_at_follow_point(node: Brioche, new_parent: Node):
	play_anim = true
	# Spawn the node
	var new_object

	if node is BriocheConfiture:
		new_object = BRIOCHE_CONFITURE.instantiate()
	elif node is Brioche:
		new_object = BRIOCHE.instantiate()
	else:
		print("faiiiiil")

	# Ensure the new object is inside the tree before setting global properties
	new_parent.add_child(new_object)
	# Now that it's added to the tree, set the local transform
	new_object.global_transform.origin = node.global_transform.origin
	new_object.global_transform.origin.y -= 0.1
	new_object.rigid_body_3d.scale = node.rigid_body_3d.scale
	new_object.change_gravity(1)

	
func spawn_bread(player: Player, player_number: int):
		if path_follow_3d.get_child_count() > 1:
			var first_child = path_follow_3d.get_child(1)
			chute.play()
			instantiate_brioche_at_follow_point(first_child, player.bread_list)
		else:
			print("No children found.")
			
func poele_anim():
	if play_anim:
		if anim_switch:
			if rotation_poele <= 180:
				rotation_poele = rotation_poele + 30
			else :
				rotation_poele = 180
				anim_switch = false
		else :
			if rotation_poele >= 0:
				rotation_poele = rotation_poele - 30
			else:
				rotation_poele = 0
				anim_switch = true
				play_anim = false
	poele.rotation_degrees = Vector3(rotation_poele, 0, 0)
	if path_follow_3d.get_child_count() > 0:
		path_follow_3d.get_child(1).rotation_degrees = Vector3(rotation_poele, 0, 0)
		
	
