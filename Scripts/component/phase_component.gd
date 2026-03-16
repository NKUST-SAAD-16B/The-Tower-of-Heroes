extends Node
class_name PhaseComponent

# 宣告進入二階段的訊號
signal phase_2_entered

# 透過 Export 在編輯器中綁定該 Boss 的血量組件
@export var health_component: HealthComponent
@export var phase_2_threshold: float = 0.5 # 預設為 50% 觸發

var is_phase_2: bool = false

func _ready() -> void:
	# 確保有綁定 HealthComponent 才能監聽血量
	if health_component:
		if not health_component.health_bar_changed.is_connected(_on_health_changed):
			health_component.health_bar_changed.connect(_on_health_changed)
	else:
		print("警告：%s 的 PhaseComponent 尚未綁定 HealthComponent！" % owner.name)

# 當血量改變時觸發
func _on_health_changed(current_health: int) -> void:
	# 如果已經是二階段，就不再重複觸發
	if is_phase_2:
		return
		
	# 計算二階段的血量門檻
	var threshold_health = health_component.max_health * phase_2_threshold
	
	# 如果當前血量低於門檻，且還沒死 (大於 0)
	if current_health <= threshold_health and current_health > 0:
		is_phase_2 = true
		phase_2_entered.emit() # 發送二階段訊號
