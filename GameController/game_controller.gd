extends Node
class_name GameController

var current_scene
@onready var world: Node = $World
@onready var soundtracks: Node = $Soundtracks

func _ready() -> void:
	Global.GAME_CONTROLLER = self
	change_scene("res://Menu/main_menu.tscn")


func change_scene(new_scene: String, params: Dictionary = {}) -> void:
	if current_scene != null:
		current_scene.queue_free()
	
	var new_scene_instance = load(new_scene).instantiate()
	
	# Check if the new scene has an `_init_params` function and call it
	if new_scene_instance.has_method("_init_params"):
		new_scene_instance._init_params(params)

	world.add_child(new_scene_instance)
	current_scene = new_scene_instance
