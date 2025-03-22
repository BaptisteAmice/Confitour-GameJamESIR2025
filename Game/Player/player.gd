extends Node3D
class_name Player

@export var key_drop: String = "enter"
@export var key_power: String = "A"
@onready var power_up_key_label: RichTextLabel = $CanvasLayer/Interface/PowerUpTextureRect/PowerUpKeyLabel
@onready var drop_key_label: RichTextLabel = $CanvasLayer/Interface/DropKeyLabel


func _ready(): 
	drop_key_label.text = key_drop + " to drop"
	power_up_key_label.text = key_power
