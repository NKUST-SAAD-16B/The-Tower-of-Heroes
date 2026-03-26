extends HealthComponent
class_name BossHealth

signal boss_health_changed(current_health, max_health)

func _ready() -> void:
	super._ready()
	# 初始化時發送一次信號
	boss_health_changed.emit(current_health, max_health)

func take_damage(damage: int) -> void:
	super.take_damage(damage)
	boss_health_changed.emit(current_health, max_health)
