extends Camera2D

@onready var h_box_container: HBoxContainer = $"../Control/PlayersHBoxContainer"
@onready var background: Node2D = $"../Background"

func _ready() -> void:
	await get_tree().process_frame  # Ensure the size is updated
	fit_to_hbox()

func fit_to_hbox() -> void:
	# Get the viewport size
	var viewport_size: Vector2 = get_viewport_rect().size
	
	# Set camera position to the center of the HBoxContainer
	var hbox_size: Vector2 = h_box_container.size
	self.position = h_box_container.global_position + (hbox_size / 2)

	# Adjust zoom to fit the entire HBoxContainer within the viewport
	if hbox_size.x > viewport_size.x or hbox_size.y > viewport_size.y:
		var zoom_x = viewport_size.x / hbox_size.x if hbox_size.x > 0 else 1
		var zoom_y = viewport_size.y / hbox_size.y if hbox_size.y > 0 else 1
		self.zoom = Vector2(min(zoom_x, zoom_y), min(zoom_x, zoom_y))
		
	background.position = self.position
