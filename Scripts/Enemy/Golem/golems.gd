extends Enemy
class_name Golem

func _ready():
	super()
	# 初始化Golem的特定屬性
	damage = 50
	walk_speed = 15
	knockback_resist = 1.0  # 完全免疫擊退
	attack_range = 40
	pass

func _hurt(knockback):
	self.knockback_vector = Vector2.ZERO  # Golem不受擊退影響
	state_machine.current_state.Transitioned.emit(state_machine.current_state, "hurt")
