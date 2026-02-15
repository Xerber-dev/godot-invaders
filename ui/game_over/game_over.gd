extends CanvasLayer



func _on_button_pressed() -> void:
	Events.new_game_requested.emit()
