extends CharacterBody2D
class_name Player

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var WALK_SPEED = 50
var RUN_SPEED = 100
var damage = 10
#擊退力量
var knockback_froce = 100
var knockback_resist = 0.9
var knockback_vector:Vector2
@onready var health_component = $HealthComponent
@onready var state_machine = $State_Machine

@onready var hitbox_1: CollisionShape2D = $HitboxComponent/Attack_1
@onready var hitbox_2: CollisionShape2D = $HitboxComponent/Attack_2
@onready var hitbox_3: CollisionShape2D = $HitboxComponent/Attack_3


func _ready() -> void:
	#連接死亡訊號
	health_component.died.connect(_on_died)
	health_component.took_damage.connect(_hurt)

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()
	if  state_machine.current_state.name not in ["attack" ,"hurt" ,"died"] :
		#切換攻擊狀態
		if Input.is_action_just_pressed("attack"):
			state_machine.current_state.Transitioned.emit(state_machine.current_state,"attack")

#死亡訊號觸發會執行_on_died()
func _on_died():
	print("玩家狀態：死亡")
	state_machine.current_state.Transitioned.emit(state_machine.current_state,"died")

#受傷訊號觸發會執行_hurt()
func _hurt(knockback):
	self.knockback_vector = knockback
	state_machine.current_state.Transitioned.emit(state_machine.current_state,"hurt")
	pass

	
