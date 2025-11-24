extends Control

#設定按鈕被按下時切換到設定畫面
func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/SettingsMenu.tscn")
	pass # Replace with function body.
