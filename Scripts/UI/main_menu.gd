extends Control

@onready var main_menu = $NinePatchRect
@onready var setting_menu = $SettingsMenu
@onready var setting_background = $Settings_background

func _ready() -> void:
	#連接設定關閉的訊號
	setting_menu.finished_settings.connect(_on_setting_menu_closed)
	pass


#接收到設定關閉時回到Main_Menu
func _on_setting_menu_closed() -> void :
	setting_background.hide()
	main_menu.show()
	pass

#當Quit按鈕被點選時
func _on_quit_pressed() -> void:
	get_tree().quit()
	
	pass
	
#設定按鈕被按下時切換到設定畫面
func _on_settings_pressed() -> void:
	main_menu.hide()
	setting_menu.show()
	setting_background.show()
	pass

#當開始遊戲按鈕被按下時，切換到遊戲場景
func _on_game_start_pressed() -> void:
	SceneChanger.change_scene("res://Scenes/World.tscn")
	PlayerData.player_data_init()
	pass 
