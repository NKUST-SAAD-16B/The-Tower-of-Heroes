extends Control

@onready var main_menu = $NinePatchRect
@onready var setting_menu = $SettingsMenu
@onready var setting_background = $Settings_background
@onready var continue_button = $NinePatchRect/VBoxContainer/Continue
@onready var easter_egg_button = $EasterEgg_Button
@onready var easter_egg_label = $EasterEgg_Label

var easter_egg_click_count : int = 0
var total_easter_egg_clicks : int = 0

func _ready() -> void:
	# 讀取存檔中的彩蛋狀態
	GameManager.load_settings_only()
	
	# 如果彩蛋已啟動，有 30% 的機率播放彩蛋音樂
	if GameManager.easter_egg_enabled and randf() < 0.3:
		AudioManager.play_bgm("haruhikage")
	else:
		# 進入時播放正常主選單音樂
		AudioManager.play_bgm("main_menu")
		
	# 連接彩蛋按鈕訊號
	easter_egg_button.pressed.connect(_on_easter_egg_pressed)

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

# 當彩蛋按鈕點擊時
func _on_easter_egg_pressed() -> void:
	easter_egg_click_count += 1
	total_easter_egg_clicks += 1
	AudioManager.play_sfx("menu_click")
	
	# 累計 50 次觸發特殊彩蛋
	if total_easter_egg_clicks >= 50:
		# 立即切換音樂
		AudioManager.play_bgm("world_is_mine")
		_show_easter_egg_label("World is Mine!")
		easter_egg_button.disabled = true
		return
	
	if easter_egg_click_count == 10:
		if GameManager.easter_egg_enabled:
			# 關閉彩蛋
			GameManager.easter_egg_enabled = false
			AudioManager.play_bgm("main_menu")
			_show_easter_egg_label("彩蛋已關閉")
		else:
			# 開啟彩蛋
			GameManager.easter_egg_enabled = true
			AudioManager.play_bgm("haruhikage")
			_show_easter_egg_label("彩蛋已觸發")
		
		# 儲存狀態並重置計數
		GameManager.save_game()
		easter_egg_click_count = 0

func _show_easter_egg_label(text: String) -> void:
	if easter_egg_label:
		easter_egg_label.text = text
		easter_egg_label.show()
		await get_tree().create_timer(3.0).timeout
		easter_egg_label.hide()

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
