extends Node2D

# 画面の中央.
const CENTER_X = 1024.0 / 2
const CENTER_Y = 600.0 / 2

onready var _camera = $MainCamera

onready var _main_layer = $MainLayer
onready var _shot_layer = $ShotLayer
onready var _particle_layer = $ParticleLayer
onready var _hdr = $WorldEnvironment

func _ready() -> void:
	var layers = {
		"main": _main_layer,
		"shot": _shot_layer,
		"particle": _particle_layer,
	}
	Common.setup(layers)

func _process(delta: float) -> void:
	_update_screen_shake(delta)
	Common.update_hitslow(delta)

func _update_screen_shake(delta:float) -> void:
	Common.update_screen_shake(delta)
	var rate = Common.get_screen_shake_rate()
	var v = 8.0 * rate
	var h = 2.0 * rate
	_camera.offset.x = rand_range(-v, v)
	_camera.offset.y = rand_range(-h, h)
