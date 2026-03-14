extends Control

# 取得兩個設定區塊的節點
@onready var audio_settings = $NinePatchRect/AudioSettings
@onready var display_settings = $NinePatchRect/DisplaySettings

# --- Display 節點 ---
@onready var window_mode_button = $NinePatchRect/DisplaySettings/WindowsMode_Button
@onready var fps_button = $NinePatchRect/DisplaySettings/FPS_Button
@onready var vsync_checkbox = $NinePatchRect/DisplaySettings/Vsync_CheckBox

# --- Audio 節點 ---
@onready var master_volume_slider = $NinePatchRect/AudioSettings/MasterVolume_HSlider2
@onready var bgm_volume_slider = $NinePatchRect/AudioSettings/BackgroundMusic_HSlider
@onready var sfx_volume_slider = $NinePatchRect/AudioSettings/Soundeffects_HSlider

# 宣告訊號，用於結束設定時發出
signal finished_settings

func _ready():
	# 初始化音量拉桿數值
	master_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))) * 100
	
	var bgm_bus_idx = AudioServer.get_bus_index("Background Music")
	if bgm_bus_idx != -1:
		bgm_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bgm_bus_idx)) * 100
	else:
		# 如果找不到 bus，初始化拉桿到 50%，但對準 Master
		bgm_volume_slider.value = 50 
		
	var sfx_bus_idx = AudioServer.get_bus_index("SFX")
	if sfx_bus_idx != -1:
		sfx_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus_idx)) * 100
	else:
		sfx_volume_slider.editable = false

	# 連結音量拉桿訊號
	master_volume_slider.value_changed.connect(_on_master_volume_changed)
	bgm_volume_slider.value_changed.connect(_on_bgm_volume_changed)
	sfx_volume_slider.value_changed.connect(_on_sfx_volume_changed)

	#載入視窗切換的選單選項
	var window_mode_popup = window_mode_button.get_popup()
	window_mode_popup.id_pressed.connect(_on_window_mode_item_pressed)
	
	#載入fps設定選單
	var fps_popup = fps_button.get_popup()
	fps_popup.id_pressed.connect(_on_fps_item_pressed)
	#vsync_checkbox.toggled.connect(_on_vsync_check_box_toggled)
	# 遊戲開始時，預設顯示 Audio，隱藏 Display
	show_audio_settings()

func _on_master_volume_changed(value: float):
	AudioManager.set_volume("Master", value / 100.0)

func _on_bgm_volume_changed(value: float):
	AudioManager.set_volume("Background Music", value / 100.0)

func _on_sfx_volume_changed(value: float):
	AudioManager.set_volume("SFX", value / 100.0)

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
	AudioManager.play_sfx("menu_click")
	show_audio_settings()
	pass

#按下Display按鈕切換到display設定畫面
func _on_display_pressed() -> void:
	AudioManager.play_sfx("menu_click")
	show_display_settings()
	pass

#點選back關閉設定畫面
func _on_back_pressed() -> void:
	AudioManager.play_sfx("menu_click")
	self.hide()
	#發出訊號，告知監聽中的節點
	finished_settings.emit()
	pass

#Vsync按鈕
func _on_vsync_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on :
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		print("垂直同步開啟")
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		print("垂直同步關閉")
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
		3: # Unlimited
			Engine.max_fps = 0
			fps_button.text = "Unlimited"
	pass
