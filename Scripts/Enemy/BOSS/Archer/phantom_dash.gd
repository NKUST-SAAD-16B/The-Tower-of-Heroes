extends State
class_name BossArcherPhantomDash

@export var dash_speed_multiplier: float = 6.0
@export var dash_duration: float = 0.8
@export var ghost_interval: float = 0.05 # 產生殘影的間隔

var timer: float = 0.0
var ghost_timer: float = 0.0

func Enter():
	# 播放跑步動畫作為衝刺動作
	animated_sprite.play("run")
	# 變半透明增加幻影感
	actor.modulate.a = 0.6
	timer = 0.0
	ghost_timer = 0.0
	
	# 關閉受傷判定 (衝刺中無敵)
	if actor.hurtbox_component:
		actor.hurtbox_component.set_deferred("monitoring", false)
		actor.hurtbox_component.set_deferred("monitorable", false)

	# 決定方向：朝向玩家衝刺 (幻影衝刺通常是穿過玩家)
	if actor.target:
		actor.direction = 1 if actor.target.global_position.x > actor.global_position.x else -1
		# 更新轉向
		if actor.direction == 1:
			actor.scale.y = 1
			actor.rotation = 0
		else:
			actor.scale.y = -1
			actor.rotation = PI
	else:
		actor.direction = [-1, 1].pick_random()

func Physics_process(delta: float) -> void:
	# 超高速移動
	actor.velocity.x = actor.direction * actor.walk_speed * dash_speed_multiplier
	
	# 產生殘影特效
	ghost_timer += delta
	if ghost_timer >= ghost_interval:
		ghost_timer = 0
		_spawn_ghost()
	
	timer += delta
	if timer >= dash_duration:
		# 衝刺結束，恢復狀態
		Transitioned.emit(self, "shoot")

func _spawn_ghost():
	# 建立一個簡單的 Sprite 作為殘影
	var ghost = Sprite2D.new()
	# 獲取當前動畫的當前幀貼圖
	var current_frame_tex = animated_sprite.sprite_frames.get_frame_texture(animated_sprite.animation, animated_sprite.frame)
	ghost.texture = current_frame_tex
	ghost.global_position = actor.global_position
	ghost.scale = actor.scale
	ghost.rotation = actor.rotation
	ghost.modulate = Color(1, 1, 1, 0.4) # 淺白色透明
	
	# 將殘影加入場景 (放在 Boss 同層或根目錄)
	get_tree().current_scene.add_child(ghost)
	
	# 使用 Tween 讓殘影淡出並自動銷毀
	var tween = create_tween()
	tween.tween_property(ghost, "modulate:a", 0.0, 0.3)
	tween.tween_callback(ghost.queue_free)

func Exit():
	# 恢復原本的屬性
	actor.modulate.a = 1.0
	actor.velocity.x = 0
	# 恢復受傷判定
	if actor.hurtbox_component:
		actor.hurtbox_component.set_deferred("monitoring", true)
		actor.hurtbox_component.set_deferred("monitorable", true)
