extends Area2D
class_name HurtBox

@onready var health_component: HealthComponent = $"../HealthComponent"


signal hurt(hitbox)

func _ready() -> void:
	hurt.connect(_on_hurt)

func _on_hurt(hitbox:HitBox):
	print("痛")
	var knockback_froce = hitbox.owner.knockback_froce
	var knockback_direction = (owner.global_position - hitbox.owner.global_position).normalized()
	var knockback_vector = knockback_direction * knockback_froce
	health_component.take_damage(hitbox.owner.damage,knockback_vector)
	
