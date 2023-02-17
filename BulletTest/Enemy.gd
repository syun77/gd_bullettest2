extends Area2D

class_name Enemy

const TIMER_SHAKE = 1.0

onready var _spr = $Enemy

var _start_pos = Vector2.ZERO
var _shake_timer = 0.0
var _knockback_velocity = Vector2()
var _cnt = 0

# ノイズテクスチャ
var _noise := OpenSimplexNoise.new()
var _noise_y := 0

func hit(vel:Vector2) -> void:
	if Common.is_knock_back():
		# ノックバックの力発生.
		_knockback_velocity = vel * 0.1
	elif Common.is_enemy_shake():
		_shake_timer = 1.0
	
	if Common.is_hitslow():
		Common.start_hitslow()
		

func _process(delta: float) -> void:
	delta *= Common.get_hitslow_rate()
	
	_cnt += 1
	_spr.modulate = Color.white
	if _knockback_velocity.length() > 0.1:
		position += _knockback_velocity * delta
		_knockback_velocity *= 0.9
		if _knockback_velocity.length() > 10:
			_spr.modulate = Color.red # ノックバック中は赤色.
	else:
		# 元の位置に戻る.
		position += (_start_pos - position) * 0.1
	
	_spr.position = Vector2.ZERO
	if _shake_timer > 0:
		_shake_timer -= delta
		var t = _shake_timer
		# 残り時間の幅でノイズテクスチャを使って揺らす
		_noise_y += 1000 * delta # 動かす
		_spr.position.x = t * (16 * _noise.get_noise_2d(_noise.seed * 2, _noise_y))
		_spr.position.y = t * (16 * _noise.get_noise_2d(_noise.seed * 3, _noise_y))

func _ready() -> void:
	_start_pos = position
