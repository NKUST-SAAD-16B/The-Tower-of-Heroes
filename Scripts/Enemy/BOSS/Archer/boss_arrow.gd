extends Area2D
class_name Arrow

@export var speed: float = 100.0

# 方向改成 Vector2 (二維向量)，預設朝右
var direction: Vector2 = Vector2.RIGHT

# --- 配合玩家 HurtBox 讀取所需要的變數 ---
var knockback_force: int = 5 # 箭矢的擊退力道
var base_damage: int = 0      # 箭矢基礎傷害

func _ready() -> void:
	
	# 當飛出螢幕時自動銷毀，節省效能
	$VisibleOnScreenNotifier2D.screen_exited.connect(queue_free)
	$HitboxComponent.area_entered.connect(_on_hitbox_entered)
func _physics_process(delta: float) -> void:
	# 改成向量移動，這樣箭矢就能朝任何角度飛
	global_position += direction * speed * delta
	#var areas = $HitboxComponent.get_overlapping_areas()
	#if areas.size() > 0:
		#print("強制物理偵測，目前箭矢重疊的區域有：", areas)

# 當箭矢的 Hitbox 碰到玩家的 Hurtbox
func _on_hitbox_entered(area: Area2D) -> void:
	if area is HurtBox and area.owner is Player:
		# 主動觸發玩家 HurtBox 的受傷訊號，並將箭矢的 HitboxComponent 傳遞過去
		# 這樣玩家的腳本中調用 hitbox.owner 時，就會完美指向這支箭矢 (Arrow)
		#area.hurt.emit($HitboxComponent)
		
		# 擊中後銷毀箭矢
		queue_free()

# --- 配合玩家 HurtBox 讀取所需要的函數 ---
func damage_calculation() -> int:
	# 這裡可以加入暴擊或其他邏輯，目前先回傳基礎傷害
	return base_damage
