extends Node2D
class_name HealthComponent

signal died

@export var max_health: int = 100
var current_health: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = max_health
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		
	pass

func take_damage(damage: int):
	current_health -= damage
	if current_health <= 0 :
		died.emit()
	
