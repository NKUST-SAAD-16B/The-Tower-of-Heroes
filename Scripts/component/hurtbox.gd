extends Area2D
class_name HurtBox

@export var damage_label : PackedScene
@onready var health_component: HealthComponent = $"../HealthComponent"
signal took_damage(knockback_vector)

signal hurt(hitbox)

func _ready() -> void:
	hurt.connect(_on_hurt)

func _on_hurt(hitbox:HitBox):
	# 創建傷害標籤並設置其位置
	var damage_label_instance = damage_label.instantiate()
	damage_label_instance.position = global_position
	get_tree().current_scene.add_child(damage_label_instance)
	damage_label_instance._damage_label(hitbox.owner.damage_calculation())
	
	#計算擊退力量
	var knockback_force = hitbox.owner.knockback_force
	#擊退方向
	var knockback_direction = Vector2(1,1) if global_position > hitbox.owner.global_position else Vector2(-1,-1)
	#計算擊退向量
	var knockback_vector = knockback_direction * knockback_force
	#發出受傷訊號並傳遞擊退向量
	took_damage.emit(knockback_vector)
	#呼叫HealthComponent的take_damage函數，傳入攻擊者的傷害值
	health_component.take_damage(hitbox.owner.damage_calculation())
	
