extends Node3D
class_name Player

@export var player_number: int
@export var key_drop: String
@export var key_power: String
@onready var power_up_key_label: RichTextLabel = $CanvasLayer/Interface/PowerUpTextureRect/PowerUpKeyLabel
@onready var drop_key_label: RichTextLabel = $CanvasLayer/Interface/DropKeyLabel
@onready var player_name_label: RichTextLabel = $CanvasLayer/Interface/PlayerNameLabel
@onready var score_label: RichTextLabel = $CanvasLayer/Interface/ScoreLabel
@onready var item_path_3d: ItemPath3D = $ItemPath3D
@onready var bread_list: Node3D = $BreadList

@onready var temp_patch_coord: float = 2.8
@onready var score: float = 0

func _ready(): 
	Global.players.push_front(self)
	update_score()
	
	var current_player_number = Global.players.size()
	player_number = current_player_number
	self.key_drop = "player_"+  str(current_player_number) + "_drop"
	self.key_power = "player_"+  str(current_player_number) + "_power"
	self.player_name_label.text = "Player " + str(current_player_number)
	
	# Retrieve the first available input action for the drop and power keys.
	var available_drop_key 
	var available_power_key
	if InputMap.action_get_events(self.key_drop).size() > 0:
		available_drop_key = InputMap.action_get_events(self.key_drop)[0].as_text()
	else:
		available_drop_key = "None"
	if InputMap.action_get_events(self.key_power).size() > 0:
		available_power_key = InputMap.action_get_events(self.key_power)[0].as_text()
	else:
		available_power_key = "None"
		
	drop_key_label.text = available_drop_key + " to drop"
	power_up_key_label.text = available_power_key
	print(Global.players)
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed(self.key_drop):
		item_path_3d.spawn_bread(self, self.player_number)
		#print(self.key_drop)
		#print(str(self.player_number) )
	if Input.is_action_just_pressed(self.key_power):
		print("I HAVE DA POWER")
	update_score()

func get_highest_bread() -> float:
	var max_y: float = -INF
	for node in bread_list.get_children():
		if node is Brioche and node.to_account_in_scoring() :
			# Access the y position from the node's transform.origin
			if node.transform.origin.y > max_y:
				max_y = node.rigid_body_3d.transform.origin.y  # Update the max_y if a higher y is found
	return max_y

func update_score():
	if len(bread_list.get_children()) > 2:
		self.score = (get_highest_bread() + temp_patch_coord) * 10
		self.score_label.text = "Score: " + str(int(self.score))
	else:
		self.score = 0
		self.score_label.text = "Score: 0"

	
	
