extends Control
class_name PlayerGameUI

#緩衝條和血條的變數
@onready var catchup_bar: TextureProgressBar = $Health/CatchupBar
@onready var health_bar: TextureProgressBar = $Health/HealthBar
@onready var shield_bar: TextureProgressBar = $Health/ShieldBar
#透過expect取得HealthComponent
@export var health_component: HealthComponent

@onready var current_floor : Label = $CurrentFloor

func _process(_delta: float) -> void:
	# 隨時更新護盾條
	_update_shield_ui()

func setup_ui() -> void:
	#初始化血條數值
	health_bar.max_value = health_component.max_health
	catchup_bar.max_value = health_component.max_health
	
	# 初始化護盾條
	shield_bar.max_value = health_component.max_health
	_update_shield_ui()
	
	#訂閱血量變化信號(傳入當前血量)
	health_component.health_bar_changed.connect(_update_bar)
	current_floor.text = "第 " + str(GameManager.current_floor) + " 層"

# 更新護盾 UI
func _update_shield_ui():
	if PlayerData.player_current_shield > 0:
		shield_bar.show()
		# 護盾長度以當前最大生命值為基準
		shield_bar.max_value = PlayerData.player_max_health
		shield_bar.value = PlayerData.player_current_shield
	else:
		shield_bar.hide()

#更新血條
func _update_bar(current_health):
	#用傳入的當前血量計算當前血條百分比
	var percentage = (current_health / float(health_component.max_health)) * 100
	
	#設置血條到當前百分比
	health_bar.value = percentage
	#這個是用於緩衝條的動畫
	var tween = create_tween()
	tween.tween_property(catchup_bar, "value", percentage, 0.4).set_trans(Tween.TRANS_SINE)
	pass
