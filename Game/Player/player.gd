extends Node3D
class_name Player

@export var player_number: int
@export var key_drop: String
@export var key_power: String
@onready var power_up_texture_rect: TextureRect = $CanvasLayer/Interface/PowerUpTextureRect
@onready var power_up_key_label: RichTextLabel = $CanvasLayer/Interface/PowerUpTextureRect/PowerUpKeyLabel
@onready var drop_key_label: RichTextLabel = $CanvasLayer/Interface/DropKeyLabel
@onready var player_name_label: RichTextLabel = $CanvasLayer/Interface/PlayerNameLabel
@onready var score_label: RichTextLabel = $CanvasLayer/Interface/ScoreLabel
@onready var item_path_3d: ItemPath3D = $ItemPath3D
@onready var bread_list: Node3D = $BreadList

@onready var score_bonus: int = 0

@onready var temp_patch_coord: float = 2.8
@onready var score: float = 0

@onready var current_power_up: String

const BRIOCHE_CONFITURE = preload("res://Game/Bodies/Brioche_confiture.tscn")
const BRIOCHE = preload("res://Game/Brioche.tscn")

const CHANCE_BRIOCHE_CONFITURE = 0.2  # 20% de chance pour Brioche Confiture

@onready var score_scale : float = 3;
@onready var score_rotate = 0;
@onready var pred_score : int = score;
@onready var available_path= ["res://Game/Path/path_I.tres", "res://Game/Path/path_X.tres","res://Game/Path/path_8.tres"]
@onready var path_for_game

@onready var camera_3d: Camera3D = $Camera3D


func _ready(): 
	camera_3d.position = Vector3(0, 4.7, -3.4)
	camera_3d.rotation = Vector3(deg_to_rad(-36), deg_to_rad(180), 0)
	Global.players.push_front(self)
	update_score()
	self.path_for_game = Select_random_path();
	$ItemPath3D.curve=load(path_for_game)
		
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
	
func spawn_random_bread():
	var bread_instance = null
	var rand_chance = randf()  # Génère un nombre aléatoire entre 0 et 1
	
	if rand_chance < CHANCE_BRIOCHE_CONFITURE:
		bread_instance = BRIOCHE_CONFITURE.instantiate()
	else:
		bread_instance = BRIOCHE.instantiate()
	bread_instance.collision_disabled = true
	return bread_instance
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed(self.key_drop):
		item_path_3d.spawn_bread(self, self.player_number)
		
		item_path_3d.change_current_spawner(spawn_random_bread())
		#print(self.key_drop)
		#print(str(self.player_number) )
	if Input.is_action_just_pressed(self.key_power):
		use_current_power_up()

	update_score()
	update_displayed_score()
	
func give_power(power: String):
	current_power_up = power
	# update sprite
	if power == "size_up":
		power_up_texture_rect.texture = load("res://Assets/sprites_128/tartine_nature_128.png")
	elif power == "jelly":
		power_up_texture_rect.texture = load("res://Assets/sprites_128/tartine_jam_128.png")
	

func use_current_power_up():
	if current_power_up:
		if current_power_up == "size_up":
			print("size_up")
			item_path_3d.get_current_spawner().scale_brioche(2)
		elif current_power_up == "jelly":
			print("jelly")
			item_path_3d.change_current_spawner(BRIOCHE_CONFITURE.instantiate())
		else:
			print("invalid power up")
	else:
			print("no power up")
	current_power_up = ""
	power_up_texture_rect.texture = load("res://Assets/sprites_128/tartine_crossed_128.png")

func get_highest_bread() -> float:
	var max_y: float = -INF
	for node in bread_list.get_children():
		if node.to_account_in_scoring() :
			# Access the y position from the node's transform.origin
			if node.rigid_body_3d.transform.origin.y > max_y:
				max_y = node.rigid_body_3d.transform.origin.y  # Update the max_y if a higher y is found
	return max_y

func update_score():
	if len(bread_list.get_children()) > 2:
		if score_bonus > 5:
			score_bonus = 5
		self.score = max(0,(get_highest_bread() + temp_patch_coord) * 10) + score_bonus
		self.score_label.text = str(int(self.score))
	else:
		self.score = 0
		self.score_label.text = "0"
		
func update_displayed_score() -> void:
	if pred_score != int(score):
		score_scale = score_scale * 1.5
		score_rotate = score_rotate + randi_range(-1, 1)
		pred_score = int(score)
	else:
		score_scale = lerp(score_scale, 1.0, 0.1)
		score_rotate = score_rotate * 0.9
		
	self.score_label.scale = Vector2(score_scale, score_scale);
	self.score_label.rotation = score_rotate

func Select_random_path():
	var random_index = randi() % available_path.size()
	# Get the random value from the array
	var random_value = available_path[random_index]
	return random_value
	
func move_camera_smooth():
	var tween = create_tween()
	tween.tween_property(camera_3d, "position", Vector3(0, 1.7, -3.5), 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(camera_3d, "rotation", Vector3(deg_to_rad(11), deg_to_rad(180), 0), 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	
	
