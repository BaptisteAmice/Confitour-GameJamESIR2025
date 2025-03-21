extends HBoxContainer
const PLAYER_VIEW = preload("res://Game/player_sub_viewport_container.tscn")
@export var nb_players: int = 2
func _ready() -> void:
	for i in range(nb_players):
		var player_sub_viewport_container = PLAYER_VIEW.instantiate()
		add_child(player_sub_viewport_container)
