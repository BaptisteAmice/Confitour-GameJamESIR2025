extends Control



const Focntionel = preload("res://Menu/font/menu.tres")
const corection = preload("res://Menu/font/MENU_pourrie.tres")
const theme_pour_clique = preload("res://Menu/font/theme_clique.tres")
@onready var main_camera: Camera2D = $"../MainCamera"
@onready var game: Game = $".."


func _ready() -> void:
	if(game.nb_players==2):
		self.global_position = main_camera.global_position/game.nb_players
	if (game.nb_players==3):
		self.global_position= main_camera.global_position
	if(game.nb_players == 4):
			self.global_position= main_camera.global_position + main_camera.global_position/2
func _on_button_button_down() -> void:
	$Button.theme=theme_pour_clique
	$Button/Timer_button1.start()
	
func _on_button_2_button_down() -> void:
	$Button2.theme=theme_pour_clique
	$Button2/Timer_button2.start()
	
func _on_button_3_button_down() -> void:
	$Button3.theme=theme_pour_clique
	$Button3/Timer_button3.start()
	
func _on_button_focus_entered() -> void:
	$Button.theme=corection
	
func _on_button_focus_exited() -> void:
	$Button.theme=Focntionel
	
func _on_button_2_focus_entered() -> void:
	$Button2.theme=corection
	
func _on_button_2_focus_exited() -> void:
	$Button2.theme=Focntionel
	
func _on_button_3_focus_exited() -> void:
	$Button3.theme=Focntionel
	
func _on_button_3_focus_entered() -> void:
	$Button3.theme=corection
	
func _on_button_mouse_entered() -> void:
	
	$Button.grab_focus() # Replace with function body.
func _on_button_2_mouse_entered() -> void:
	
	$Button2.grab_focus() # Replace with function body.
func _on_button_3_mouse_entered() -> void:
	$Button3.grab_focus()


func _on_timer_button_1_timeout() -> void:
	Global.GAME_CONTROLLER.change_scene("res://Menu/main_menu.tscn")
	Global.GAME_CONTROLLER.change_scene("res://Game/game.tscn", {"nb_player": game.nb_players})


func _on_timer_button_2_timeout() -> void:
	Global.GAME_CONTROLLER.change_scene("res://Menu/main_menu.tscn")


func _on_timer_button_3_timeout() -> void:
	get_tree().quit()
