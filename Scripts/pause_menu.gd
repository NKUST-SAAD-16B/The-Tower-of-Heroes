extends Control

@onready var setting_menu = $SettingsMenu
@onready var pause_menu = $VBoxContainer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#暫停選單打開時，先把設定選單藏起來
	setting_menu.hide()
	#顯示暫停選單
	pause_menu.show()
	#連接設定關閉的訊號
	setting_menu.finished_settings.connect(_on_setting_menu_closed)
	pass 

#接收到設定關閉時回到Pause_Menu
func _on_setting_menu_closed() -> void:
	pause_menu.show()
	pass
	
#當設定按鈕被點選時
func _on_settings_pressed() -> void:
	pause_menu.hide()
	setting_menu.show()
	pass

#當Title按鈕被點選時
func _on_title_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	pass
