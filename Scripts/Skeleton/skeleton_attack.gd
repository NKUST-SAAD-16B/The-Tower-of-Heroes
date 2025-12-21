extends State
class_name SkeletonAttack

func Enter():
	animated_sprite.play("attack")
	if not animated_sprite.frame_changed.is_connected(_on_animated_sprite_2d_frame_changed):
		animated_sprite.frame_changed.connect(_on_animated_sprite_2d_frame_changed)
	if not animated_sprite.animation_finished.is_connected(_on_animation_sprite_2d_animation_finished):
		animated_sprite.animation_finished.connect(_on_animation_sprite_2d_animation_finished)
	pass

func Exit():
	animated_sprite.stop()
	actor.attack.set_deferred("disabled", true)
	if animated_sprite.frame_changed.is_connected(_on_animated_sprite_2d_frame_changed):
		animated_sprite.frame_changed.disconnect(_on_animated_sprite_2d_frame_changed)
	pass

func Physics_process(delta: float) -> void :
	actor.velocity.x = 0
	pass




func _on_animation_sprite_2d_animation_finished() -> void:
	if actor.target is Player and abs(actor.target.global_position.x - actor.global_position.x) <= 25:
		#處理攻擊轉向
		actor.direction = 1 if actor.target.global_position.x > actor.global_position.x else -1
		if actor.direction == 1:
			actor.scale.y = 1
			actor.rotation = 0
		else:
			actor.scale.y = -1
			actor.rotation = PI
		Transitioned.emit(self,"attack")
	elif actor.target is Player:
		Transitioned.emit(self,"chase")
	else:
		Transitioned.emit(self,"walk")

func _on_animated_sprite_2d_frame_changed() -> void:
	#print("1")
	if animated_sprite.animation == "attack" and animated_sprite.frame == 7:
		actor.attack.set_deferred("disabled", false)
	else:
		actor.attack.set_deferred("disabled", true)
	pass # Replace with function body.
