extends Node

@onready var bgm_player = AudioStreamPlayer.new()

var bgm_tracks = {
	"dungeon": preload("res://Sound/BGM/Dungeon-Crawler.wav"),
	"main_menu": preload("res://Sound/BGM/Element.mp3"),
	"haruhikage": preload("res://Sound/BGM/Haruhikage.mp3"),
	"world_is_mine": preload("res://Sound/BGM/world is mine.mp3")
}

var sfx_samples = {
	"player_hurt": preload("res://Sound/SFX/player_hurt.wav"),
	"menu_click": preload("res://Sound/SFX/Menu_SFX.wav"),
	"pause_click": preload("res://Sound/SFX/Pause_SFX.wav"),
	"enemy_hit": preload("res://Sound/SFX/crunch_quick.wav"),
	"sword_slash": preload("res://Sound/SFX/Sword Slash.wav")
}

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(bgm_player)
	bgm_player.bus = "Background Music"
	
	# 連接 finished 訊號以實現循環播放
	bgm_player.finished.connect(_on_bgm_finished)
	
	# 如果沒有 Background Music 總線，則預設使用 Master
	if AudioServer.get_bus_index("Background Music") == -1:
		bgm_player.bus = "Master"
	
	# 遊戲啟動時預設音量：Master 與 BGM 均設為 50%
	#set_volume("Master", 0.5)
	#set_volume("Background Music", 0.5)
	# SFX 預設 80%
	#set_volume("SFX", 0.8) 

func play_bgm(track_name: String):
	if bgm_tracks.has(track_name):
		if bgm_player.stream == bgm_tracks[track_name] and bgm_player.playing:
			return
		bgm_player.stream = bgm_tracks[track_name]
		bgm_player.play()

func stop_bgm():
	bgm_player.stop()

func _on_bgm_finished():
	bgm_player.play()

func play_sfx(sample_name: String):
	if sfx_samples.has(sample_name):
		var sfx_player = AudioStreamPlayer.new()
		add_child(sfx_player)
		sfx_player.stream = sfx_samples[sample_name]
		sfx_player.bus = "SFX"
		sfx_player.play()
		# 播放完畢後自動刪除播放器
		sfx_player.finished.connect(sfx_player.queue_free)

func set_volume(bus_name: String, value_normalized: float):
	var bus_index = AudioServer.get_bus_index(bus_name)
	
	if bus_index == -1:
		if bus_name != "Master":
			print("警告：找不到音軌總線 ", bus_name, "。請在 Godot 編輯器中建立它。")
		return
		
	# 將 0.0-1.0 轉換為分貝 (dB)
	var db = linear_to_db(value_normalized)
	AudioServer.set_bus_volume_db(bus_index, db)
	
	# 如果值極小，則靜音該總線
	AudioServer.set_bus_mute(bus_index, value_normalized <= 0.0001)
