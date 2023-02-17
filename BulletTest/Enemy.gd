extends Area2D

class_name Enemy

onready var _spr = $Enemy

var _cnt = 0

func _physics_process(delta: float) -> void:
	delta *= Common.get_hitslow_rate()
	
	_cnt += 1
