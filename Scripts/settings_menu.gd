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
	pass

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
	pass
