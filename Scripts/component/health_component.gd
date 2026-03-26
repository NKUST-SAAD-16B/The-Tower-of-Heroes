extends Node2D
class_name HealthComponent

#死亡時發送的訊號
signal died
#受傷時發送的訊號

signal health_bar_changed(current_health)
@export var max_health: int = 100
var current_health: int


func _ready() -> void:
	if get_parent() is Player:
		max_health = PlayerData.player_max_health
		current_health = PlayerData.player_current_health
	else:
		current_health = max_health

func _process(_delta: float) -> void:
	# 如果是玩家，隨時監控 PlayerData 是否有外部改動（如商店扣血）
	if get_parent() is Player:
		if current_health != PlayerData.player_current_health:
			current_health = PlayerData.player_current_health
			health_bar_changed.emit(current_health)
		if max_health != PlayerData.player_max_health:
			max_health = PlayerData.player_max_health


# 受傷函數，用於血量計算
func take_damage(damage: int) -> void:
	var remaining_damage = damage
	
	# 如果是玩家受到傷害，先計算護盾
	if get_parent() is Player:
		if PlayerData.player_current_shield > 0:
			var shield_block = min(PlayerData.player_current_shield, remaining_damage)
			PlayerData.player_current_shield -= shield_block
			remaining_damage -= shield_block
			print("護盾抵擋了 %d 點傷害，剩餘護盾: %d" % [shield_block, PlayerData.player_current_shield])
	
	# 扣除剩餘傷害
	current_health -= remaining_damage
	
	# 如果是玩家，將更新後的血量同步回 PlayerData
	if get_parent() is Player:
		PlayerData.player_current_health = current_health
		
	print("%s Current Health: %d" % [get_parent().name, current_health])
	# 訊號通知血量條有變化
	health_bar_changed.emit(current_health)
	
	# 如果血量小於 0 就發出死亡訊號
	if current_health <= 0:
		died.emit()
		
