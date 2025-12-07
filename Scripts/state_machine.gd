extends Node
#初始狀態
@export var inital_state : State
#當前狀態
var current_state : State
#把所有狀態放入字典
var states : Dictionary = {}

func _ready():

	#歷遍子節點，將狀態加入字典
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			#將狀態加入節點時順便連接訊號
			child.Transitioned.connect(on_child_transition)
	
	if inital_state:
		inital_state.Enter()
		current_state = inital_state
		
func _process(delta: float) -> void:
	#如果當前狀態存在，就持續運作
	if current_state:
		current_state.Update(delta)

func _physics_process(delta: float) -> void:
	#如果當前狀態存在，就持續運作
	if current_state:
		current_state.Physics_process(delta)
	pass
	
func on_child_transition(state , new_state_name):
	#確認是否由當前狀態觸發的
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	
	if !new_state:
		return
		
	if current_state:
		current_state.Exit()
	
	new_state.Enter()
	
	current_state = new_state
