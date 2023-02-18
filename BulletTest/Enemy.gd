extends Area2D

class_name Enemy

const BulletObj = preload("res://Bullet.tscn")

# --------------------------------
# class.
# --------------------------------
class DelayedBatteryInfo:
	var deg:float = 0
	var speed:float = 0
	var delay:float = 0
	var ax:float = 0
	var ay:float = 0
	func _init(_deg:float, _speed:float, _delay:float, _ax:float=0.0, _ay:float=0.0) -> void:
		deg = _deg
		speed = _speed
		delay = _delay
		ax = _ax
		ay = _ay
	func elapse(delta:float) -> bool:
		delay -= delta
		if delay <= 0:
			return true # 発射できる.
		return false


onready var _spr = $Enemy

var _cnt = 0
var _timer = 0.0
var _batteries = [] # 弾のディレイ発射用配列.

func _physics_process(delta: float) -> void:
	_timer += delta
	_cnt += 1
	
	_update_batteies(delta)
	
	if _cnt%60 == 0:
		var aim = _aim()
		#_bullet(aim, 500)
		for i in range(7):
			_nway(3, aim, 45, 300+50*i, 0.1 * i)

func _aim() -> float:
	return Common.get_aim(position)

## 弾を撃つ.
func _bullet(deg:float, speed:float, delay:float=0, ax:float=0, ay:float=0) -> void:
	if delay > 0.0:
		# 遅延発射なのでリストに追加するだけ.
		_add_battery(deg, speed, delay, ax, ay)
		return
	
	# 発射する.
	var b = BulletObj.instance()
	b.position = position
	b.set_velocity(deg, speed)
	b.set_accel(ax, ay)
	var bullets = Common.get_layer("bullet")
	bullets.add_child(b)

## N-Wayを撃つ
## @param n 発射数.
## @param center 中心角度.
## @param wide 範囲.
## @param speed 速度.
## @param delay 遅延速度.
func _nway(n, center, wide, speed, delay=0) -> void:
	if n < 1:
		return
	
	var d = wide / n
	var a = center - (d * 0.5 * (n - 1))
	for i in range(n):
		_bullet(a, speed, delay)
		a += d

## 遅延発射リストに追加する.
func _add_battery(deg:float, speed:float, delay:float, ax:float, ay:float) -> void:
	var b = DelayedBatteryInfo.new(deg, speed, delay, ax, ay)
	_batteries.append(b)

## 遅延発射リストを更新する.
func _update_batteies(delta:float) -> void:
	var tmp = []
	for battery in _batteries:
		var b:DelayedBatteryInfo = battery
		if b.elapse(delta):
			# 発射する.
			_bullet(b.deg, b.speed, 0, b.ax, b.ay)
			continue
		
		# 発射できないのでリストに追加.
		tmp.append(b)
	
	_batteries = tmp
