extends Control

@onready var main_menu = $NinePatchRect
@onready var setting_menu = $SettingsMenu
@onready var setting_background = $Settings_background
@onready var continue_button = $NinePatchRect/VBoxContainer/Continue

func _ready() -> void:
	AudioManager.play_bgm("main_menu")
	# 連接設定關閉的訊號
	if setting_menu.has_signal("finished_settings"):
		setting_menu.finished_settings.connect(_on_setting_menu_closed)
	
	# 檢查是否有存檔
	if not GameManager.has_save_file():
		continue_button.disabled = true
		continue_button.modulate.a = 0.5
	else:
		# 確保 Continue 按鈕點擊後執行 load_game
		if not continue_button.pressed.is_connected(_on_continue_pressed):
			continue_button.pressed.connect(_on_continue_pressed)

# 接收到設定關閉時回到 Main_Menu
func _on_setting_menu_closed() -> void:
	setting_background.hide()
	main_menu.show()

# 當 Quit 按鈕被點選時
func _on_quit_pressed() -> void:
	AudioManager.play_sfx("menu_click")
	get_tree().quit()

# 設定按鈕被按下時切換到設定畫面
func _on_settings_pressed() -> void:
	AudioManager.play_sfx("menu_click")
	main_menu.hide()
	setting_menu.show()
	setting_background.show()

# 當開始遊戲按鈕被按下時，初始化並開啟新局
func _on_game_start_pressed() -> void:
	AudioManager.play_sfx("menu_click")
	GameManager.start_new_game()

# 當繼續遊戲按鈕被按下時，讀取存檔
func _on_continue_pressed() -> void:
	AudioManager.play_sfx("menu_click")
	GameManager.load_game()
