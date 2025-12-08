extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var WALK_SPEED = 50
var direction = 1

@onready var health_component = $HealthComponent
@onready var state_machine = $State_Machine

@onready var wall_check: RayCast2D = $WallCheck
@onready var player_check: RayCast2D = $PlayerCheck
@onready var floor_check: RayCast2D = $FloorCheck

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
