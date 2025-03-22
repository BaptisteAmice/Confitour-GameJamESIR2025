extends Node3D
class_name Player

@export var player_name: String = "player"
@export var key_drop: String
@export var key_power: String
@onready var power_up_key_label: RichTextLabel = $CanvasLayer/Interface/PowerUpTextureRect/PowerUpKeyLabel
@onready var drop_key_label: RichTextLabel = $CanvasLayer/Interface/DropKeyLabel


func _ready(): 
	Global.players.push_front(self)
	
	var current_player_number = Global.players.size()
	key_drop = "player_"+  str(current_player_number) + "_drop"
	key_power = "player_"+  str(current_player_number) + "_power"
	
	
	
	drop_key_label.text = key_drop + " to drop"
	power_up_key_label.text = key_power
	print(Global.players)
	
