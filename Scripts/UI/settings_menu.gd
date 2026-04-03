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

# 存檔檔案路徑
const SAVE_PATH = "user://settings.save"

# 宣告訊號，用於結束設定時發出
signal finished_settings

func _ready():
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

	if not has_save_file():
		print("找不到設定檔案，將使用預設設定。")
		# 遊戲啟動時預設音量：Master 與 BGM 均設為 50%
		AudioManager.set_volume("Master", 0.5)
		AudioManager.set_volume("Background Music", 0.5)
		# SFX 預設 80%
		AudioManager.set_volume("SFX", 0.8) 
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
		

	else:
		print("找到設定檔案，正在載入設定...")
		_load_settings() # 載入設定，恢復之前的設置狀態

	
	

func _on_master_volume_changed(value: float):
	AudioManager.set_volume("Master", value / 100.0)
	_save_settings()

func _on_bgm_volume_changed(value: float):
	AudioManager.set_volume("Background Music", value / 100.0)
	_save_settings()

func _on_sfx_volume_changed(value: float):
	AudioManager.set_volume("SFX", value / 100.0)
	_save_settings()

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
	_save_settings()
	pass

#Vsync按鈕
func _on_vsync_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on :
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		print("垂直同步開啟")
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		print("垂直同步關閉")
	_save_settings()
	pass

# 處理視窗模式切換
func _on_window_mode_item_pressed(id: int):
	print("收到按鈕訊號，ID 是: ", id)
	match id:
		0: # Windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			window_mode_button.text = "視窗" # 更新按鈕文字
		1: # Full Screen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			window_mode_button.text = "全螢幕" # 更新按鈕文字
	_save_settings()
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
	_save_settings()
	pass


func _save_settings():
	#創建一個字典來保存遊戲的設置數據
	var settings_data = {
		"audio": {
			"master_volume": db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))),
			"bgm_volume": db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Background Music"))),
			"sfx_volume": db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))),
			"master_volume_slider_value": master_volume_slider.value,
			"bgm_volume_slider_value": bgm_volume_slider.value,
			"sfx_volume_slider_value": sfx_volume_slider.value
		},
		"display": {
			"window_mode": DisplayServer.window_get_mode(),
			"fps_limit": Engine.max_fps,
			"vsync_enabled": DisplayServer.window_get_vsync_mode(),
			"window_mode_button_text": window_mode_button.text,
			"fps_button_text": fps_button.text,
			"vsync_checkbox_toggled": vsync_checkbox.button_pressed
		}
	}
	#將save_data轉換為JSON字符串，並寫入到指定的存檔路徑中
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	
	if file:
		var json_string = JSON.stringify(settings_data)
		file.store_string(json_string)
		file.close()
		print("設定已儲存至: ", SAVE_PATH)

func _load_settings():
	if not has_save_file():
		print("找不到設定檔案！")
		return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		file.close()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if parse_result == OK:
			var settings_data = json.data
			var audio_data = settings_data.get("audio", {})
			var display_data = settings_data.get("display", {})
			
			# 恢復音量設定
			AudioManager.set_volume("Master", audio_data.get("master_volume", 0.5))
			AudioManager.set_volume("Background Music", audio_data.get("bgm_volume", 0.5))
			AudioManager.set_volume("SFX", audio_data.get("sfx_volume", 0.8))
			master_volume_slider.value = audio_data.get("master_volume_slider_value", 50)
			bgm_volume_slider.value = audio_data.get("bgm_volume_slider_value", 50)
			sfx_volume_slider.value = audio_data.get("sfx_volume_slider_value", 80)
			
			# 恢復顯示設定
			var window_mode = display_data.get("window_mode", DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_mode(window_mode)
			window_mode_button.text = display_data.get("window_mode_button_text", "視窗")
			Engine.max_fps = display_data.get("fps_limit", 60)
			fps_button.text = display_data.get("fps_button_text", "60")
			var vsync_enabled = display_data.get("vsync_enabled", false)
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if vsync_enabled else DisplayServer.VSYNC_DISABLED)
			vsync_checkbox.button_pressed = bool(display_data.get("vsync_checkbox_toggled", false))
			print("設定已載入，顯示模式: ", window_mode_button.text, " FPS限制: ", fps_button.text, " Vsync: ", vsync_checkbox.button_pressed)

# 檢查是否有設定存檔
func has_save_file() -> bool:
	return FileAccess.file_exists(SAVE_PATH)
