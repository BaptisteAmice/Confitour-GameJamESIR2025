extends Path3D

@onready var path_follow_3d: PathFollow3D = $PathFollow3D

func _ready() -> void:
	path_follow_3d.progress = 1

func _on_timer_timeout() -> void:
	path_follow_3d.progress += 0.01  # Move the PathFollow3D every 2 seconds
	print("aaa")
