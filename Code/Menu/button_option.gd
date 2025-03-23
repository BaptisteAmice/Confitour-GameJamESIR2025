extends Button


func go_to_options():
	Global.GAME_CONTROLLER.change_scene("res://Game/settings.tscn")
		


func _on_button_down() -> void:
	go_to_options()
