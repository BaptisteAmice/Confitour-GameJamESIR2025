extends Node


@export var base_nb_player_number: int = 2
@onready var nbp_layer_h_slider: HSlider = $NBPLayerHSlider
@onready var player_number_label: Label = $PlayerNumberLabel

func _ready() -> void:
	nbp_layer_h_slider.value = base_nb_player_number
	var soundtracks = Global.GAME_CONTROLLER.soundtracks.get_children()
	soundtracks[0].play()
	
func _init_params(params: Dictionary) -> void:
	pass

func launch_game_nb_player(nb_players):
	Global.GAME_CONTROLLER.change_scene("res://Game/game.tscn", {"nb_player": nb_players})
		
func _on_button_button_down() -> void:
	launch_game_nb_player(base_nb_player_number)

func _on_nbp_layer_h_slider_value_changed(value: float) -> void:
	base_nb_player_number = nbp_layer_h_slider.value
	player_number_label.text = str(base_nb_player_number)
