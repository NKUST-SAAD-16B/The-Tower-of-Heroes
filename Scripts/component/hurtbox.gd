extends Area2D
class_name HurtBox

@onready var health_component: HealthComponent = $"../HealthComponent"


signal hurt(hitbox)

func _ready() -> void:
	hurt.connect(_on_hurt)

func _on_hurt(hitbox:HitBox):
	print("痛")
	health_component.take_damage(hitbox.owner.damage)
	
