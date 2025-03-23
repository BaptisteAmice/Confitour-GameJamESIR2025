extends Node

@export var base_nb_player_number: int = 2
@onready var nbp_layer_h_slider: HSlider = $NBPLayerHSlider
@onready var player_number_label: Label = $PlayerNumberLabel
@onready var timer: Timer = $Button/Timer
@onready var timer_button_2: Timer = $Button2/Timer_button2

@onready var game_time_label: Label = $GameTimeLabel
@onready var game_time_h_slider: HSlider = $GameTimeHSlider
@export var game_time_from_menu: int = 60 

const Focntionel = preload("res://Menu/font/menu.tres")
const corection = preload("res://Menu/font/MENU_pourrie.tres")
const theme_pour_clique = preload("res://Menu/font/theme_clique.tres")

func _ready() -> void:
	Global.players = []
	nbp_layer_h_slider.value = base_nb_player_number
	game_time_h_slider.value = game_time_from_menu
	var soundtracks = Global.GAME_CONTROLLER.soundtracks.get_children()
	soundtracks[0].play()

func _init_params(params: Dictionary) -> void:
	pass

func launch_game_nb_player(nb_players):
	Global.GAME_CONTROLLER.change_scene("res://Game/game.tscn", {"nb_player": nb_players, "time": game_time_from_menu})

func _on_button_button_down() -> void:
	$Button.theme=theme_pour_clique
	timer.start()

func _on_nbp_layer_h_slider_value_changed(value: float) -> void:
	base_nb_player_number =  nbp_layer_h_slider.value
	player_number_label.text = "Players: " + str(base_nb_player_number)

func _on_button_2_button_down() -> void:
	$Button2.theme=theme_pour_clique
	timer_button_2.start()

func _on_timer_timeout() -> void:
	launch_game_nb_player(base_nb_player_number)
func _on_button_focus_entered() -> void:
	# L'état focus du bouton est activé
	$Button.theme=corection

func _on_button_focus_exited() -> void:
	# L'état focus du bouton est désactivé
	$Button.theme=Focntionel


func _on_button_2_focus_entered() -> void:
	$Button2.theme=corection


func _on_button_2_focus_exited() -> void:
	$Button2.theme=Focntionel


func _on_timer_button_2_timeout() -> void:
	Global.GAME_CONTROLLER.change_scene("res://Menu/keybinding setting/keybind.tscn")


func _on_button_mouse_entered() -> void:
	$Button.grab_focus() # Replace with function body.


func _on_button_2_mouse_entered() -> void:
	$Button2.grab_focus() # Replace with function body.


func _on_exit_button_button_down() -> void:
	get_tree().quit()


func _on_game_time_h_slider_value_changed(value: float) -> void:
	game_time_from_menu = int(value)
	$GameTimeLabel.text = "Time: " + str(int(value))
