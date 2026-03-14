extends Control
class_name PlayerGameUI

#緩衝條和血條的變數
@onready var catchup_bar: TextureProgressBar = $Health/CatchupBar
@onready var health_bar: TextureProgressBar = $Health/HealthBar
#透過expect取得HealthComponent
@export var health_component: HealthComponent

@onready var current_floor : Label = $CurrentFloor

@onready var current_enemy_quantity : Label = $VBoxContainer/CurrentEnemyQuantity


func setup_ui() -> void:
	#初始化血條數值
	health_bar.max_value = health_component.max_health
	catchup_bar.max_value = health_component.max_health
	#訂閱血量變化信號(傳入當前血量)
	health_component.health_bar_changed.connect(_update_bar)
	current_floor.text = "第 " + str(GameManager.current_floor) + " 層"

	#訂閱敵人數量變化的信號，當敵人數量變化時更新顯示
	if not GameManager.enemy_quantity_changed.is_connected(_update_current_enemy_quantity):
		GameManager.enemy_quantity_changed.connect(_update_current_enemy_quantity)
	current_enemy_quantity.text = str(GameManager.current_enemy_quantity)



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

func _update_current_enemy_quantity():
	current_enemy_quantity.text = str(GameManager.current_enemy_quantity)