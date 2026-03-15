extends Control

@onready var setting_menu = $SettingsMenu
@onready var pause_menu = $VBoxContainer

@onready var save_button = $VBoxContainer/Save

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#暫停選單打開時，先把設定選單藏起來
	setting_menu.hide()
	#顯示暫停選單
	pause_menu.show()
	#連接設定關閉的訊號
	setting_menu.finished_settings.connect(_on_setting_menu_closed)
	
	# 連接儲存按鈕
	if not save_button.pressed.is_connected(_on_save_pressed):
		save_button.pressed.connect(_on_save_pressed)

@onready var save_status_label = $VBoxContainer/SaveStatusLabel

var save_tween: Tween

# 當儲存按鈕被點選時
func _on_save_pressed() -> void:
	AudioManager.play_sfx("pause_click")
	GameManager.save_game()
	print("遊戲進度已儲存")
	
	# 顯示「存檔成功」提示
	if save_status_label:
		save_status_label.show()
		save_status_label.modulate.a = 1.0
		
		# 如果之前有正在執行的動畫，先停止它
		if save_tween:
			save_tween.kill()
		
		# 建立淡出動畫
		save_tween = create_tween()
		# 這裡需要設定為即便暫停也能跑 (PauseMenu 本身 process_mode 就是 2，所以通常沒問題)
		save_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		# 等待 2 秒後開始淡出
		save_tween.tween_interval(2.0)
		save_tween.tween_property(save_status_label, "modulate:a", 0.0, 1.0)
		save_tween.tween_callback(save_status_label.hide)

#接收到設定關閉時回到Pause_Menu
func _on_setting_menu_closed() -> void:
	pause_menu.show()
	pass
	
#當設定按鈕被點選時
func _on_settings_pressed() -> void:
	AudioManager.play_sfx("pause_click")
	pause_menu.hide()
	setting_menu.show()
	print("進入設定選單")
	pass

#當Title按鈕被點選時
func _on_title_pressed() -> void:
	AudioManager.play_sfx("pause_click")
	get_tree().paused = false
	print("返回主選單")
	SceneChanger.change_scene("res://Scenes/UI/MainMenu.tscn")
	pass


func _on_resume_pressed() -> void:
	AudioManager.play_sfx("pause_click")
	print("遊戲繼續")
	get_tree().paused = false
	self.hide()
	pass 
