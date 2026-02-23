extends Area2D
class_name HitBox

signal hit(hurtBox)

signal hit_shake(intensity: float)

func _init() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(hurtbox:HurtBox) -> void:
	print("[Hit] %s -> [Hurt] %s" % [owner.name , hurtbox.owner.name])
	hit.emit(hurtbox)
	hurtbox.hurt.emit(self)
	hit_shake.emit(4) # 傳遞震動強度
	pass
