extends Node2D
class_name HealthComponent

#死亡時發送的訊號
signal died
#受傷時發送的訊號

signal health_bar_changed(current_health)
@export var max_health: int = 100
var current_health: int


func _ready() -> void:
	current_health = max_health
	pass


#受傷函數，用於血量計算
func take_damage(damage: int ) -> void:
	current_health -= damage
	print("%s Current Health: %d" % [get_parent().name, current_health])
	#訊號通知血量條有變化
	health_bar_changed.emit(current_health)
	
	#如果血量小於0就發出死亡訊號，沒有就發出受傷訊號並傳遞擊退速度
	if current_health <= 0 :
		died.emit()
		

