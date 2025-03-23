extends Node2D
class_name Game

@export var nb_players: int = 2
@onready var players_h_box_container: HBoxContainer = $Control/PlayersHBoxContainer
@onready var timer_label: RichTextLabel = $Control/TimerLabel
@onready var game_timer: Timer = $GameTimer
@onready var winners: Node = $Winners

@onready var clocks: Node = $Clocks
@onready var clockplayed : int = 0

@onready var pred_game_timer: int
@onready var timer_scale : float = 0;
@onready var timer_rotate = 0;

@export var power_up_times: Array[float] = [5,20,40,60,80,100,110,120,130,140,150,160,170,180,200,255,398,1000]

@onready var available_powers = ["size_up","jelly"]

var game_time: int

func _init_params(params: Dictionary) -> void:
	if params.has("nb_player"):
		nb_players = params["nb_player"]
		game_time = params["time"]
		
func _ready() -> void:
	game_timer.set_wait_time(game_time)
	print(game_timer.get_wait_time())
	pred_game_timer = int(game_timer.time_left)
	game_timer.start()
	
	var soundtracks = Global.GAME_CONTROLLER.soundtracks.get_children()
	soundtracks[0].stop()
	soundtracks[1].play()
	
	timer_label.text = str(int(game_timer.time_left))
	
	timer_label.position = $MainCamera.position + Vector2(0, 300) - timer_label.size/2
	$end_control.visible=false
	$end_control/ColorRect/Player.visible=false
	$end_control/ColorRect/Player2.visible=false
	$end_control/ColorRect/Player3.visible=false
	$end_control/ColorRect/Player4.visible=false


func _on_game_timer_timeout() -> void:
	var max_scoring_player_number = get_max_scoring_player_number()
	print("winner is player ", str(max_scoring_player_number))
	var winners_list = winners.get_children()
	winners_list[max_scoring_player_number-1].play()
	
	if (max_scoring_player_number==1):
		$end_control/ColorRect/Player.visible=true
	elif (max_scoring_player_number==2):
		$end_control/ColorRect/Player2.visible=true
	elif (max_scoring_player_number==3):
		$end_control/ColorRect/Player3.visible=true
	elif (max_scoring_player_number==4):
		$end_control/ColorRect/Player4.visible=true
	$end_control.visible=true
	

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
	
	
func get_random_power_up():
	# Get a random index
	var random_index = randi() % available_powers.size()

	# Get the random value from the array
	var random_value = available_powers[random_index]
	return random_value
		
func try_to_give_power():
	var elapsed_time = game_timer.wait_time - game_timer.time_left
	if len(power_up_times) > 0 and elapsed_time > power_up_times[0]:
		for player in Global.players:
			player.give_power(get_random_power_up())
		power_up_times.remove_at(0)
		
		
		
		

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
	try_to_give_power()
