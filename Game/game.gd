extends Node2D
class_name Game

@export var nb_players: int = 2
@onready var players_h_box_container: HBoxContainer = $Control/PlayersHBoxContainer
@onready var timer_label: RichTextLabel = $Control/TimerLabel
@onready var game_timer: Timer = $GameTimer
@onready var winners: Node = $Winners

@onready var clocks: Node = $Clocks
@onready var clockplayed : int = 0

@onready var pred_game_timer: int = int(game_timer.time_left)
@onready var timer_scale : float = 0;
@onready var timer_rotate = 0;

@export var power_up_times: Array[float] = [1,5,20]

func _init_params(params: Dictionary) -> void:
	if params.has("nb_player"):
		nb_players = params["nb_player"]
		
func _ready() -> void:
	var soundtracks = Global.GAME_CONTROLLER.soundtracks.get_children()
	soundtracks[0].stop()
	soundtracks[1].play()
	
	timer_label.text = str(int(game_timer.time_left))
	
	timer_label.position = $MainCamera.position + Vector2(0, 300) - timer_label.size/2


func _on_game_timer_timeout() -> void:
	var max_scoring_player_number = get_max_scoring_player_number()
	print("winner is player ", str(max_scoring_player_number))
	var winners_list = winners.get_children()
	winners_list[max_scoring_player_number-1].play()
	

func get_max_scoring_player_number():
	var max_score: int = -INF
	var max_scoring_player_number: int = 0
	for player in Global.players:
		player.update_score()
		# Update the max_score when a new higher score is found
		if player.score > max_score:
			max_score = player.score  # This line was missing in your code
			max_scoring_player_number = player.player_number
		print("player", player.player_number, "score", player.score)
	
	return max_scoring_player_number

func _process(delta: float) -> void:
	if game_timer.time_left < 30.0 and clockplayed == 0: 
		var clocklist = clocks.get_children()
		print("time left 30")
		clocklist[0].play()
		clockplayed +=1
	if game_timer.time_left < 15.0 and clockplayed ==1:
		var clocklist = clocks.get_children()
		print("time left 15")
		clockplayed +=1
		clocklist[1].play()
		
	update_displayed_game_timer()
		
func try_to_use_power():
	#if len(power_up_times) > 0 and game_timer. > power_up_times[0]:
	pass
		
		

func update_displayed_game_timer() -> void:
	if pred_game_timer != int(game_timer.time_left):
		if game_timer.time_left < 10:
			timer_scale = timer_scale * 10
			#timer_color = 1
		else:
			timer_scale = timer_scale * 1.5

		timer_rotate = timer_rotate + randi_range(-1, 1)
		pred_game_timer = int(game_timer.time_left)
	else:
		timer_scale = lerp(timer_scale, 1.0, 0.1)
		timer_rotate = timer_rotate * 0.9    
	self.timer_label.scale = Vector2(timer_scale, timer_scale);
	self.timer_label.rotation = timer_rotate

func _on_seconds_timer_timeout() -> void:
	timer_label.text = str(int(game_timer.time_left))
