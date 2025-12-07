extends State
class_name Died

#進入狀態時執行
func  Enter():
	actor.velocity.x = 0
	animated_sprite.play("died")
	if not animated_sprite.animation_finished.is_connected(_on_lose):
		animated_sprite.animation_finished.connect(_on_lose)
	pass

#離開狀態時執行
func Exit():
	animated_sprite.stop()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_lose() -> void:
	Transitioned.emit(self,"idle")
	pass
