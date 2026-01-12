extends Control

# 取得兩個設定區塊的節點
@onready var audio_settings = $NinePatchRect/AudioSettings
@onready var display_settings = $NinePatchRect/DisplaySettings

# --- Display 節點 ---
@onready var window_mode_button = $NinePatchRect/DisplaySettings/WindowsMode_Button
@onready var fps_button = $NinePatchRect/DisplaySettings/FPS_Button
@onready var vsync_checkbox = $NinePatchRect/DisplaySettings/Vsync_CheckBox

# 宣告訊號，用於結束設定時發出
signal finished_settings

func _ready():
	#載入視窗切換的選單選項
	var window_mode_popup = window_mode_button.get_popup()
	window_mode_popup.id_pressed.connect(_on_window_mode_item_pressed)
	
	#載入fps設定選單
	var fps_popup = fps_button.get_popup()
	fps_popup.id_pressed.connect(_on_fps_item_pressed)
	#vsync_checkbox.toggled.connect(_on_vsync_check_box_toggled)
	# 遊戲開始時，預設顯示 Audio，隱藏 Display
	show_audio_settings()

# --- 自定義函式：顯示 Audio 頁面 ---
func show_audio_settings():
	audio_settings.visible = true
	display_settings.visible = false

# --- 自定義函式：顯示 Display 頁面 ---
func show_display_settings():
	audio_settings.visible = false
	display_settings.visible = true
	

#按下Audio按鈕切換到audio設定畫面
func _on_audio_pressed() -> void:
	show_audio_settings()
	pass

#按下Display按鈕切換到display設定畫面
func _on_display_pressed() -> void:
	show_display_settings()
	pass

#點選back關閉設定畫面
func _on_back_pressed() -> void:
	self.hide()
	#發出訊號，告知監聽中的節點
	finished_settings.emit()

#Vsync按鈕
func _on_vsync_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on :
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		print("垂直同步開啟")
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		print("垂直同步關閉")

# 處理視窗模式切換
func _on_window_mode_item_pressed(id: int):
	print("收到按鈕訊號，ID 是: ", id)
	match id:
		0: # Windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			window_mode_button.text = "Windowed" # 更新按鈕文字
		1: # Full Screen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			window_mode_button.text = "Full Screen" # 更新按鈕文字

#處理fps切換
func _on_fps_item_pressed(id: int):
	match id:
		0: # fps30
			Engine.max_fps = 30
			fps_button.text = "30"
		1: # fps60
			Engine.max_fps = 60
			fps_button.text = "60"
		2: # fps120
			Engine.max_fps = 120
			fps_button.text = "120"
		3:
			Engine.max_fps = 240
			fps_button.text = "240"
