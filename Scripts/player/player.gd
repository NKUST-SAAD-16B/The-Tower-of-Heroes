extends CharacterBody2D
class_name Player

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var walk_speed = 50
var run_speed = 100
var damage = 50
var player_scale = 0.6

#擊退力量相關
var knockback_force = 50
var knockback_resist = 0.9
var knockback_vector:Vector2

@onready var hurtbox_component: HurtBox = $HurtboxComponent
@onready var health_component = $HealthComponent
@onready var state_machine = $State_Machine

@onready var hitbox_1: CollisionShape2D = $HitboxComponent/Attack_1
@onready var hitbox_2: CollisionShape2D = $HitboxComponent/Attack_2
@onready var hitbox_3: CollisionShape2D = $HitboxComponent/Attack_3


func _ready() -> void:
	#連接死亡訊號
	health_component.died.connect(_on_died)
	#連接受傷訊號
	hurtbox_component.took_damage.connect(_hurt)
	#同步玩家數據
	sync_player_data()
	#連接HealthComponent的血量變化訊號，當血量變化時更新PlayerData中的玩家當前血量
	health_component.health_bar_changed.connect(func(current_health):
		PlayerData.player_current_health = current_health
	)


func _physics_process(delta: float) -> void:
	#基本重力和移動
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()
	#攻擊輸入檢測，當前狀態不在攻擊、受傷、死亡狀態時才允許切換到攻擊狀態
	if  state_machine.current_state.name not in ["attack" ,"hurt" ,"died"] :
		#切換攻擊狀態
		if Input.is_action_just_pressed("attack"):
			state_machine.current_state.Transitioned.emit(state_machine.current_state,"attack")

#死亡訊號觸發會執行_on_died()
func _on_died():
	
	state_machine.current_state.Transitioned.emit(state_machine.current_state,"died")

#受傷訊號觸發會執行_hurt()
func _hurt(knockback):
	self.knockback_vector = knockback
	state_machine.current_state.Transitioned.emit(state_machine.current_state,"hurt")
	pass

#同步玩家數據
func sync_player_data():
	self.walk_speed = PlayerData.player_walk_speed
	self.run_speed = PlayerData.player_run_speed
	self.damage = PlayerData.player_damage
	self.player_scale = PlayerData.player_scale
	health_component.max_health = PlayerData.player_max_health
	health_component.current_health = PlayerData.player_current_health
