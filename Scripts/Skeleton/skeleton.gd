extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var WALK_SPEED = 30
var damage = 20
var direction = 1
var knockback_resist = 0.9
var knockback_vector:Vector2
var knockback_froce = 50
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
	health_component.took_damage.connect(_hurt)
	
func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()

#死亡訊號觸發會執行_died()
func _died():
	print("you died")
	state_machine.current_state.Transitioned.emit(state_machine.current_state,"died")

#受傷訊號觸發會執行_hurt()
func _hurt(knockback):
	self.knockback_vector = knockback
	state_machine.current_state.Transitioned.emit(state_machine.current_state,"hurt")
	pass

#當目標進入偵測區域時，target賦值並切換到chase狀態
func _on_player_checker_body_entered(body: Node2D) -> void:
	print("偵測到玩家")
	if body is Player:
		target = body
		state_machine.current_state.Transitioned.emit(state_machine.current_state,"chase")
	pass

#當目標離開偵測區域時，將target清空
func _on_player_checker_body_exited(body: Node2D) -> void:
	target = null
	pass
	
