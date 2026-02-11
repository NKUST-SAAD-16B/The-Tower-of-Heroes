extends Node


var player_current_health : int
var player_max_health : int = 100
var player_damage : int
var player_walk_speed : int
var player_run_speed : int
var player_scale : float

func player_data_init():
    player_current_health = player_max_health
    player_damage = 10
    player_walk_speed = 50
    player_run_speed = 100
    player_scale = 0.6