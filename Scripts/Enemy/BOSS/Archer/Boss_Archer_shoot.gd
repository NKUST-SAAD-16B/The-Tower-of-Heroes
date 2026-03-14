extends EnemyAttack
class_name BossArcherShoot

@export var arrow_scene: PackedScene # 在屬性面板把你的箭矢場景拖進來
@export var shoot_position: Marker2D # 在屬性面板把剛剛建的 Marker2D 拖進來

func Enter():
	# 播放射擊動畫
	animated_sprite.play("shoot")
	
	# 連接訊號 (沿用父類別的邏輯架構)
	if not animated_sprite.frame_changed.is_connected(_on_animated_sprite_2d_frame_changed):
		animated_sprite.frame_changed.connect(_on_animated_sprite_2d_frame_changed)
	if not animated_sprite.animation_finished.is_connected(_on_animation_sprite_2d_animation_finished):
		animated_sprite.animation_finished.connect(_on_animation_sprite_2d_animation_finished)

# 覆寫父類別的函數：當動畫播到指定幀數時，生成箭矢而不是開啟 Hitbox
func _on_animated_sprite_2d_frame_changed() -> void:
	if animated_sprite.animation == "shoot" and animated_sprite.frame == attack_frame:
		shoot_arrow()

# 獨立出發射箭矢的邏輯
func shoot_arrow():
	if arrow_scene == null:
		return
	
	# 如果進入二階段，一次射出 3 支箭 (扇形)
	if actor.phase_component.is_phase_2:
		# 定義 3 個角度偏移 (以弧度為單位，約 -15度, 0度, 15度)
		var angles = [-0.26, 0, 0.26] 
		for offset in angles:
			create_single_arrow(offset)
	else:
		# 一階段：正常單射
		create_single_arrow(0)

# 建立單支箭矢並設定方向
func create_single_arrow(angle_offset: float):
	var arrow = arrow_scene.instantiate()
	get_tree().current_scene.add_child(arrow)
	
	if shoot_position:
		arrow.global_position = shoot_position.global_position
		
		var aim_direction: Vector2
		if actor.target:
			var target_pos = actor.target.global_position + Vector2(0, -15)
			aim_direction = shoot_position.global_position.direction_to(target_pos)
		else:
			# 如果沒有目標，朝向 Boss 的正面
			var shoot_dir_x = 1 if actor.scale.y == 1 else -1
			aim_direction = Vector2(shoot_dir_x, 0)
			
		# 套用角度偏移 (旋轉向量)
		aim_direction = aim_direction.rotated(angle_offset)
		
		# 設定箭矢屬性
		arrow.rotation = aim_direction.angle()
		arrow.direction = aim_direction
	else:
		arrow.global_position = actor.global_position
		var shoot_direction = 1 if actor.scale.y == 1 else -1 
		arrow.direction = Vector2(shoot_direction, 0).rotated(angle_offset)
		arrow.rotation = arrow.direction.angle()
func Exit():
	animated_sprite.stop()
	
	# 因為是遠程攻擊，我們不需要處理 actor.attack.set_deferred
	
	# 確實斷開在 Enter() 時連接的訊號，避免影響後續狀態
	if animated_sprite.frame_changed.is_connected(_on_animated_sprite_2d_frame_changed):
		animated_sprite.frame_changed.disconnect(_on_animated_sprite_2d_frame_changed)
		
	if animated_sprite.animation_finished.is_connected(_on_animation_sprite_2d_animation_finished):
		animated_sprite.animation_finished.disconnect(_on_animation_sprite_2d_animation_finished)
# 覆寫父類別的 Physics_process

func Physics_process(delta: float) -> void:
	# 射擊時不要移動
	actor.velocity.x = 0
	
	# 如果有鎖定玩家，就持續讓 Boss 面對玩家
	if actor.target is Player:
		# 判斷玩家在 Boss 的左邊還是右邊
		actor.direction = 1 if actor.target.global_position.x > actor.global_position.x else -1
		
		# 立刻執行轉向 (套用你原本寫的轉向邏輯)
		if actor.direction == 1:
			actor.scale.y = 1
			actor.rotation = 0
		else:
			actor.scale.y = -1
			actor.rotation = PI
