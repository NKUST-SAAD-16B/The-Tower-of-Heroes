extends CharacterBody2D
class_name Enemy
# 敵人基底類別

# 基本屬性，可在繼承的子類別中覆寫
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var walk_speed = 30
var base_damage = 10
var direction = 1
var knockback_resist = 0.9
var knockback_vector:Vector2
var knockback_force = 50

var attack_range = 25
#偵測對象
var target:CharacterBody2D = null

@onready var health_component = $HealthComponent
@onready var state_machine = $State_Machine

@onready var hurtbox_component: HurtBox = $HurtboxComponent
@onready var attack: CollisionShape2D = $HitboxComponent/Attack

#RayCast2D的變數
@onready var wall_check: RayCast2D = $WallCheck
@onready var floor_check: RayCast2D = $FloorCheck

@onready var player_checker: Area2D = $PlayerChecker

func _ready() -> void:
	#連接死亡訊號
	health_component.died.connect(_died)
	#連接受傷訊號
	hurtbox_component.took_damage.connect(_hurt)
	
func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()

#死亡訊號觸發會執行_died()
func _died():
	print("%s：死亡" % [name])
	state_machine.current_state.Transitioned.emit(state_machine.current_state,"died")

#受傷訊號觸發會執行_hurt()
func _hurt(knockback):
	self.knockback_vector = knockback
	state_machine.current_state.Transitioned.emit(state_machine.current_state,"hurt")
	pass

#當目標進入偵測區域時，target賦值並切換到chase狀態
func _on_player_checker_body_entered(body: Node2D) -> void:
	print("%s：偵測到玩家" % [name])
	if body is Player:
		target = body
		state_machine.current_state.Transitioned.emit(state_machine.current_state,"chase")
	pass

#當目標離開偵測區域時，將target清空
func _on_player_checker_body_exited(body: Node2D) -> void:
	target = null
	print("%s：玩家離開偵測範圍" % [name])
	pass

func damage_calculation():
	#計算傷害值，根據暴擊機率決定是否暴擊
	var damage = base_damage * (1 + DestinyManager.enemy_damage_modifier) #敵人傷害計算公式待調整，先這樣乘不讓選事件時報錯
	return damage