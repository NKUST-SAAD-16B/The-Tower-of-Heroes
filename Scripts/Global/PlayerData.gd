extends Node


var player_current_health : int
var player_max_health : int = 100
var player_base_damage : int
var player_bonus_damage : int
var player_critical_chance : float
var player_critical_multiplier : float
var player_walk_speed : int
var player_run_speed : int
var player_scale : float

func player_data_init():
    player_current_health = player_max_health
    player_base_damage = 50
    player_bonus_damage = 0
    player_critical_chance = 0.0
    player_critical_multiplier = 1.5
    player_walk_speed = 50
    player_run_speed = 100
    player_scale = 0.6