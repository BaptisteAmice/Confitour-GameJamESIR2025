extends Control

@onready var input_button_scene = preload("res://Menu/keybinding setting/input_button_settings.tscn")
@onready var action_list: VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/ActionList


var is_remapping = false
var action_to_remap = null
var remapping_button = null

# Cette fonction est appelée au démarrage
func _ready():
	_load_input_map()  # Charge les actions personnalisées depuis le singleton InputManager
	_create_action_list()

# Charge les actions personnalisées du singleton InputManager
func _load_input_map():
	Global.GAME_CONTROLLER.input_manager.load_custom_actions()  # Charge les actions personnalisées

# Crée la liste des actions et boutons
func _create_action_list():
	_clear_action_list()  # Efface les anciens éléments

	var buttons = []

	# Crée un bouton pour chaque action, sauf celles qui commencent par "ui_"
	for action in InputMap.get_actions():
		if action.begins_with("ui_"):
			continue

		var button = _create_action_button(action)
		action_list.add_child(button)
		buttons.append(button)

	# Configure les voisins de chaque bouton pour la navigation avec le focus
	_set_button_focus_navigation(buttons)

	# Donne le focus au premier bouton
	if buttons.size() > 0:
		buttons[0].grab_focus()

# Crée un bouton pour une action donnée
func _create_action_button(action: String) -> Button:
	var button = input_button_scene.instantiate()
	button.focus_mode = Control.FOCUS_ALL  # Important pour que le bouton soit focusable
	var action_label = button.find_child("labelaction")
	var input_label = button.find_child("Input")
	action_label.text = action

	var events = InputMap.action_get_events(action)
	if events.size() > 0:
		input_label.text = _get_event_display_name(events[0])
	else:
		input_label.text = ""

	button.pressed.connect(_on_input_button_pressed.bind(button, action))
	return button

# Efface tous les enfants de la liste d'actions (pour éviter de créer des doublons)
func _clear_action_list():
	for item in action_list.get_children():
		item.queue_free()

# Configure les voisins des boutons pour la navigation avec le focus
func _set_button_focus_navigation(buttons: Array):
	for i in range(buttons.size()):
		var btn = buttons[i]
		if i > 0:
			btn.set_focus_neighbor(SIDE_TOP, buttons[i - 1].get_path())
		if i < buttons.size() - 1:
			btn.set_focus_neighbor(SIDE_BOTTOM, buttons[i + 1].get_path())

	var soundtrack_slider = $PanelContainer/MarginContainer/VBoxContainer/SoundTrack_master
	var last_btn = buttons[buttons.size() - 1]
	last_btn.set_focus_neighbor(SIDE_BOTTOM, soundtrack_slider.get_path())
	soundtrack_slider.set_focus_neighbor(SIDE_TOP, last_btn.get_path())

# Fonction appelée quand un bouton d'entrée est pressé
func _on_input_button_pressed(button, action):
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("Input").text = "Press key or button..."

# Gère les entrées de l'utilisateur
func _input(event: InputEvent):
	if is_remapping:
		if (
			event is InputEventKey
			|| (event is InputEventMouseButton && event.pressed)
			|| (event is InputEventJoypadButton && event.pressed)
		):
			if event is InputEventMouseButton and event.double_click:
				event.double_click = false

			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)
			_update_action_list(remapping_button, event)

			# Sauvegarde dans le singleton InputManager
			Global.GAME_CONTROLLER.input_manager.custom_actions[action_to_remap] = [event]
			Global.GAME_CONTROLLER.input_manager.save_custom_actions()

			is_remapping = false
			action_to_remap = null
			remapping_button = null

			accept_event()

# Met à jour l'affichage de l'action dans la liste
func _update_action_list(button, event):
	button.find_child("Input").text = _get_event_display_name(event)

# Formate et retourne le nom de l'événement pour l'affichage
func _get_event_display_name(event: InputEvent) -> String:
	if event is InputEventJoypadButton:
		return "Joypad Button %d" % event.button_index
	elif event is InputEventKey or event is InputEventMouseButton:
		return event.as_text().trim_suffix(" (Physical)")
	else:
		return event.as_text()

# Retourne au menu principal
func _on_button_button_down() -> void:
	Global.GAME_CONTROLLER.change_scene("res://Menu/main_menu.tscn")
