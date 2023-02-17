extends Node

const ParticleObj = preload("res://Particle.tscn")
const TIMER_SCREEN_SHAKE = 1.0

var _change_spr = false
var _is_scatter = false
var _scatter_range = 5.0
var _is_offset = false
var _is_particle = false
var _layers = null
var _is_screen_shake = false
var _is_enemy_shake = false
var _screen_shake_timer = 0.0
var _is_knock_back = false
var _is_hitslow = false
var _hitslow_rate = 40
var _hitslow_timer = 0.0
var _is_blur = false
var _is_trail = false

func setup(layers) -> void:
	_layers = layers
	
func start_screen_shake() -> void:
	_screen_shake_timer = TIMER_SCREEN_SHAKE
func get_screen_shake_rate() -> float:
	return _screen_shake_timer / TIMER_SCREEN_SHAKE
func update_screen_shake(delta:float) -> void:
	_screen_shake_timer -= delta
	if _screen_shake_timer < 0:
		_screen_shake_timer = 0

func get_layer(name:String) -> CanvasLayer:
	return _layers[name]

func add_particle(pos:Vector2, t:float, deg:float, speed:float):
	var p = ParticleObj.instance()
	p.position = pos
	p.start(t, deg, speed)
	get_layer("particle").add_child(p)
	return p

func set_change_spr(b:bool) -> void:
	_change_spr = b

func is_change_spr() -> bool:
	return _change_spr

func set_scatter(b:bool) -> void:
	_is_scatter = b
func is_scatter() -> bool:
	return _is_scatter

func set_scatter_range(v:float) -> void:
	_scatter_range = v
func get_scatter_range() -> float:
	return _scatter_range

func set_offset(b:bool) -> void:
	_is_offset = b
func is_offset() -> bool:
	return _is_offset

func set_particle(b:bool) -> void:
	_is_particle = b
func is_particle() -> bool:
	return _is_particle

func set_screen_shake(b:bool) -> void:
	_is_screen_shake = b
func is_screen_shake() -> bool:
	return _is_screen_shake
func set_enemy_shake(b:bool) -> void:
	_is_enemy_shake = b
func is_enemy_shake() -> bool:
	return _is_enemy_shake

func set_knock_back(b:bool) -> void:
	_is_knock_back = b
func is_knock_back() -> bool:
	return _is_knock_back

func set_hitslow(b:bool) -> void:
	_is_hitslow = b
func is_hitslow() -> bool:
	return _is_hitslow
func set_hitslow_rate(rate:int) -> void:
	_hitslow_rate = rate
func get_hitslow_rate() -> float:
	if _hitslow_timer <= 0:
		return 1.0 # 無効.
	return _hitslow_rate / 100.0
func start_hitslow() -> void:
	_hitslow_timer = 1.0
func update_hitslow(delta:float) -> void:
	_hitslow_timer -= delta
	
func set_blur(b:bool) -> void:
	_is_blur = b
func is_blur() -> bool:
	return _is_blur

func set_trail(b:bool) -> void:
	_is_trail = b
func is_trail() -> bool:
	return _is_trail

## 角度差を求める.
func diff_angle(now:float, next:float) -> float:
	# 角度差を求める.
	var d = next - now
	# 0.0〜360.0にする.
	d -= floor(d / 360.0) * 360.0
	# -180.0〜180.0の範囲にする.
	if d > 180.0:
		d -= 360.0
	return d
