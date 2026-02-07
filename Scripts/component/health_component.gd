extends Node2D
class_name HealthComponent

#死亡時發送的訊號
signal died
#受傷時發送的訊號

signal health_bar_changed(current_health)
@export var max_health: int = 100
var current_health: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = max_health
	pass # Replace with function body.


#受傷函數，用於血量計算及傳入攻擊者的擊退向量
func take_damage(damage: int ,knockback_vector: Vector2 = Vector2.ZERO):
	current_health -= damage
	
	#訊號通知血量條有變化
	health_bar_changed.emit(current_health)
	
	#如果血量小於0就發出死亡訊號，沒有就發出受傷訊號並傳遞擊退速度
	if current_health <= 0 :
		died.emit()
		
	
