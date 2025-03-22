extends Path3D

@onready var path_follow_3d: PathFollow3D = $PathFollow3D
@export var progress_speed: float = 2  # Speed of the path following, adjusted based on delta time
@onready var bread_list: Node3D = $"../BreadList"
@onready var player: Player = $".."

func _ready() -> void:
	path_follow_3d.progress = 1

func _physics_process(delta: float) -> void:
	# Update progress based on delta time to ensure consistent movement regardless of frame rate
	path_follow_3d.progress += progress_speed * delta
	
	if Input.is_action_just_pressed(player.key_drop):
		spawn_bread()
	if Input.is_action_just_pressed(player.key_power):
		print("I HAVE DA POWER")
	

	
func duplicate_at_follow_point(node: Node3D, new_parent: Node):
	# Duplicate the node
	var new_object = node.duplicate()

	# Ensure the new object is inside the tree before setting global properties
	new_parent.add_child(new_object)

	# Now that it's added to the tree, set the local transform
	new_object.global_transform.origin = node.global_transform.origin
	new_object.scale = node.scale

	
func spawn_bread():
	if path_follow_3d.get_child_count() > 0:
		var first_child = path_follow_3d.get_child(0)
		duplicate_at_follow_point(first_child, bread_list)
	else:
		print("No children found.")
	
	
