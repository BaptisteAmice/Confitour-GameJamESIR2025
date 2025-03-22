extends Node2D
class_name Game

@export var nb_players: int = 2
@onready var players_h_box_container: HBoxContainer = $Control/PlayersHBoxContainer
@onready var timer_label: RichTextLabel = $Control/TimerLabel
@onready var game_timer: Timer = $GameTimer

func _init_params(params: Dictionary) -> void:
	if params.has("nb_player"):
		nb_players = params["nb_player"]
		
func _ready() -> void:
	var soundtracks = Global.GAME_CONTROLLER.soundtracks.get_children()
	soundtracks[0].stop()
	soundtracks[1].play()
	
	timer_label.text = str(int(game_timer.time_left))


func _on_game_timer_timeout() -> void:
	pass # Replace with function body.


func _on_seconds_timer_timeout() -> void:
	timer_label.text = str(int(game_timer.time_left))
