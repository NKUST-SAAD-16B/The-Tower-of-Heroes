extends Node

class_name State

@onready var player: CharacterBody2D = $"../.."
@onready var animated_sprite : AnimatedSprite2D = $"../../AnimatedSprite2D"

#當要離開狀態時就觸發這個訊號
signal Transitioned

#進入狀態時執行
func  Enter():
	
	pass

#離開狀態時執行
func Exit():
	
	pass


func Update(delta: float) -> void :
	
	pass

func Physics_process(delta: float) -> void :
	pass
