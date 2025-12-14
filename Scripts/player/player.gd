extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var WALK_SPEED = 50
var RUN_SPEED = 100
var damage = 10
#擊退力量
var knockback_froce = 20

@onready var health_component = $HealthComponent
@onready var state_machine = $State_Machine

@onready var hitbox_1: CollisionShape2D = $HitboxComponent/Attack_1
@onready var hitbox_2: CollisionShape2D = $HitboxComponent/Attack_2
@onready var hitbox_3: CollisionShape2D = $HitboxComponent/Attack_3


func _ready() -> void:
	#連接死亡訊號
	health_component.died.connect(_on_died)
	

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()

#死亡訊號觸發會執行_on_died()
func _on_died():
	print("you died")
	state_machine.current_state.Exit()
	state_machine.current_state = $State_Machine/died
	state_machine.current_state.Enter()
