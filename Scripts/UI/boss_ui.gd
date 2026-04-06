extends Control
class_name BossUI

@onready var catchup_bar: TextureProgressBar = $CatchupBar
@onready var health_bar: TextureProgressBar = $HealthBar


@onready var health_component: BossHealth = $"../../HealthComponent"
func _ready() -> void:
	#初始化血條數值
	health_bar.max_value = health_component.max_health
	catchup_bar.max_value = health_component.max_health
	health_bar.value = health_component.current_health
	catchup_bar.value = health_component.current_health
	
	#訂閱血量變化信號(傳入當前血量)
	if not health_component.health_bar_changed.is_connected(_update_bar):
		health_component.health_bar_changed.connect(_update_bar)

func _update_bar(current_health):
	health_bar.value = current_health
	
	# 使用 Tween 來平滑更新緩衝條
	var tween = create_tween()
	tween.tween_property(catchup_bar, "value", current_health, 0.5) # 0.5秒內更新到當前血量
