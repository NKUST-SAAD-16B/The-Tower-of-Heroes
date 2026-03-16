extends Node

signal gold_quantity_changed

var player_current_health : int
var player_max_health : int = 100
var player_current_shield : int = 0
var player_base_damage : int
var player_bonus_damage : int
var player_critical_chance : float
var player_critical_multiplier : float
var player_walk_speed : int
var player_run_speed : int
var player_scale : float

var gold_quantity : int = 0:
    set(value):
        gold_quantity = value
        gold_quantity_changed.emit() #當金幣數量變化時，觸發gold_quantity_changed信號，通知UI更新顯示

func player_data_init():
	player_current_health = player_max_health
	player_current_shield = 0
	player_base_damage = 50
	player_bonus_damage = 0
	player_critical_chance = 0.0
	player_critical_multiplier = 1.5
	player_walk_speed = 50
	player_run_speed = 100
	player_scale = 0.6
