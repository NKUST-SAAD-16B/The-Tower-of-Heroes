extends Area2D
class_name HurtBox

@export var damage_label : PackedScene
@onready var health_component: HealthComponent = $"../HealthComponent"
signal took_damage(knockback_vector)
#傳遞給防禦狀態的訊號，讓防禦狀態知道玩家被攻擊了)
signal defense_hit(attacker_position:Vector2, defense_result:Dictionary)

signal hurt(hitbox)

func _ready() -> void:
	hurt.connect(_on_hurt)

func _on_hurt(hitbox:HitBox):
	#攻擊者位置
	var hitbox_owner_position = hitbox.owner.global_position
	#定義一個字典來存儲防禦結果，初始值為false，當防禦狀態接收到defense_hit訊號後會根據攻擊者位置來判斷是否成功格擋，並修改這個字典中的值，讓hurtbox知道是否成功格擋了攻擊
	var defense_result = {"success": false}
	#發出防禦訊號，傳遞攻擊者位置(有監聽這個訊號的只有玩家的防禦狀態，當玩家在防禦狀態時會根據攻擊者位置來決定是否成功格擋)
	defense_hit.emit(hitbox_owner_position, defense_result)
	#如果成功格擋了攻擊，則不執行後續的受傷和擊退邏輯
	if defense_result["success"]:
		return
	else:
		print("玩家未能格擋攻擊，受到傷害！")
	#傷害計算
	var hitbox_damage = hitbox.owner.damage_calculation()
	# 創建傷害標籤並設置其位置
	var damage_label_instance = damage_label.instantiate()
	damage_label_instance.position = global_position
	get_tree().current_scene.add_child(damage_label_instance)
	damage_label_instance._damage_label(hitbox_damage)
	
	#計算擊退力量
	var knockback_force = hitbox.owner.knockback_force
	#擊退方向
	var knockback_direction = Vector2(1,1) if global_position > hitbox.owner.global_position else Vector2(-1,-1)
	#計算擊退向量
	var knockback_vector = knockback_direction * knockback_force
	#發出受傷訊號並傳遞擊退向量
	took_damage.emit(knockback_vector)
	#呼叫HealthComponent的take_damage函數，傳入攻擊者的傷害值
	health_component.take_damage(hitbox_damage)
	
