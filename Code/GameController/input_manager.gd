extends Node

# Variable pour stocker les actions modifiées
var custom_actions = {}

# Fonction pour enregistrer les actions
func save_custom_actions():
	# Sauvegarde des actions modifiées dans les paramètres du projet
	for action in custom_actions.keys():
		InputMap.action_erase_events(action)
		for event in custom_actions[action]:
			InputMap.action_add_event(action, event)
	ProjectSettings.save()

# Fonction pour charger les actions sauvegardées
func load_custom_actions():
	custom_actions.clear()
	for action in InputMap.get_actions():
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			custom_actions[action] = events
