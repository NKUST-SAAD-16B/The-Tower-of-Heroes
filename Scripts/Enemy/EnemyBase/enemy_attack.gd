extends State
class_name EnemyAttack

@export var attack_frame : int #攻擊動畫中哪一幀開啟攻擊判定，需自行調整以配合動畫
func Enter():
	print("%s：攻擊", actor.name)
	animated_sprite.play("attack")
	#避免重複連接訊號
	if not animated_sprite.frame_changed.is_connected(_on_animated_sprite_2d_frame_changed):
		animated_sprite.frame_changed.connect(_on_animated_sprite_2d_frame_changed)
	if not animated_sprite.animation_finished.is_connected(_on_animation_sprite_2d_animation_finished):
		animated_sprite.animation_finished.connect(_on_animation_sprite_2d_animation_finished)
	pass

func Exit():
	animated_sprite.stop()
	actor.attack.set_deferred("disabled", true)
	#斷開訊號
	if animated_sprite.frame_changed.is_connected(_on_animated_sprite_2d_frame_changed):
		animated_sprite.frame_changed.disconnect(_on_animated_sprite_2d_frame_changed)
	pass

func Physics_process(delta: float) -> void :
	actor.velocity.x = 0
	#在攻擊狀態不斷偵測玩家方向，以便攻擊動畫完成後知道玩家的方向決定該往哪轉
	if actor.target is Player:
		actor.direction = 1 if actor.target.global_position.x > actor.global_position.x else -1
	
	pass


func _on_animation_sprite_2d_animation_finished() -> void:
	#攻擊動畫完成後會先轉向
	if actor.direction == 1:
		actor.scale.y = 1
		actor.rotation = 0
	else:
		actor.scale.y = -1
		actor.rotation = PI
	#如果玩家還在攻擊範圍內就再次攻擊
	if actor.target is Player and actor.global_position.distance_to(actor.target.global_position) <= actor.attack_range:
		Transitioned.emit(self,"attack")
	#玩家還在範圍內就回到chase狀態
	elif actor.target is Player:
		Transitioned.emit(self,"chase")
	#如果沒有偵測到玩家就回到walk狀態
	else:
		Transitioned.emit(self,"walk")

#當攻擊動畫到特定frame時開啟hitbox
#大部分敵人攻擊動畫只有一個frame有攻擊判定，但如果有多個frame需要開啟攻擊判定可以Orrveide這個函數並自行調整
func _on_animated_sprite_2d_frame_changed() -> void:
	#print("1")
	if animated_sprite.animation == "attack" and animated_sprite.frame == attack_frame:
		actor.attack.set_deferred("disabled", false)
	else:
		actor.attack.set_deferred("disabled", true)
	pass # Replace with function body.
