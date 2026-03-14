extends State
class_name EnemyDied

@onready var gold_scene: PackedScene = preload("res://Scenes/Character/Gold.tscn")
func Enter():
	print("%s：死亡" % [actor.name])
	actor.velocity.x = 0
	if not animated_sprite.animation_finished.is_connected(Exit):
		animated_sprite.animation_finished.connect(Exit)
	#停止偵測攻擊
	actor.hurtbox_component.set_deferred("monitoring", false)
	actor.hurtbox_component.set_deferred("monitorable", false)
	animated_sprite.play("died")
	
	pass

func Exit():
	# 生成金幣
	drop_gold()
	actor.queue_free()
	GameManager.current_enemy_quantity -= 1
	pass

func Update(delta: float) -> void :
	
	pass

func Physics_process(delta: float) -> void :
	pass

func drop_gold(amount: int = actor.gold_drop_amount) -> void:
	# 生成金幣
	for i in range(amount):
		var gold = gold_scene.instantiate()
		actor.get_parent().call_deferred("add_child", gold)
		gold.position = actor.position
