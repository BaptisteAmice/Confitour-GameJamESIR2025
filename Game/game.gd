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
	var max_scoring_player_number = get_max_scoring_player_number()
	

func get_max_scoring_player_number():
	var max_score: int = -INF
	var max_scoring_player_number: int = 0
	for player in Global.players:
		player.update_score()
		if player.score > max_score:
			max_scoring_player_number = player.player_number
	return max_scoring_player_number


func _on_seconds_timer_timeout() -> void:
	timer_label.text = str(int(game_timer.time_left))
	print("str"+str(get_max_scoring_player_number()))
