extends CanvasLayer
class_name PlayerGameUI

#緩衝條和血條的變數
@onready var catchup_bar: TextureProgressBar = $Health/CatchupBar
@onready var health_bar: TextureProgressBar = $Health/HealthBar
#透過expect取得HealthComponent
@export var health_component: HealthComponent


func _ready() -> void:
	# 初始化血條數值
	health_bar.max_value = 100
	catchup_bar.max_value = 100
	# 訂閱血量變化信號(傳入當前血量)
	health_component.health_bar_changed.connect(_update_bar)
	pass

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
