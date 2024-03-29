extends Area2D

class_name Shot2

@onready var _line = $Line2D

# 移動方向.
var _deg := 0.0
# 速度.
var _speed := 0.0

# 経過時間
var _timer := 0.0

## 速度をベクトルとして取得する.	
func get_velocity() -> Vector2:
	var v = Vector2()
	var rad = deg_to_rad(_deg)
	v.x = cos(rad) * _speed
	v.y = -sin(rad) * _speed
	return v

## 消滅する
func vanish() -> void:
	if Common.is_particle() == false:
		# パーティクルなし.
		queue_free()
		return
	
	# 逆方向にパーティクルを発生させる.
	var v = get_velocity() * -1
	var spd = v.length()
	for i in range(4):
		var rad = atan2(-v.y, v.x)
		var deg = rad_to_deg(rad)
		deg += randf_range(-30, 30)
		var speed = spd * randf_range(0.1, 0.5)
		Common.add_particle(position, 1.0, deg, speed)
	queue_free()

## 一番近いターゲットを探す.
func _search_target():
	var target_layer = Common.get_layer("main")
	var distance:float = 999999
	var target:Node2D = null
	for obj in target_layer.get_children():
		if not obj is Enemy:
			continue
		var d = (obj.position - position).length()
		if d < distance:
			# より近いターゲット.
			target = obj
			distance = d
	
	return target	
## 速度を設定.
func set_velocity(v:Vector2) -> void:
	_deg = rad_to_deg(atan2(-v.y, v.x))
	_speed = v.length()
	
## 更新.
func _process(delta: float) -> void:
	_timer += delta
	
	_speed += 1000 * delta # 加速する.
	if _speed > 5000:
		_speed = 5000 # 最高速度制限.
	
	var target = _search_target()
	if target != null:
		# 速度を更新.
		var d = target.position - position
		# 狙い撃ち角度を計算する.
		var aim = rad_to_deg(atan2(-d.y, d.x))
		var diff = Common.diff_angle(_deg, aim)
		# 旋回する.
		_deg += diff * delta * 3 + (diff * _timer * (delta+0.5))
	
	var v = get_velocity()
	
	# 移動量.
	var d = v * delta
	position += d
	
	# line2Dの更新.
	# positionに追従してしまうので逆オフセットが必要となる.
	for i in range(_line.points.size()):
		_line.points[i] -= d # すべてのLine2Dの位置を移動量で逆オフセットする.
	_line.points[0] = Vector2.ZERO # 先頭は0でよい.
	_update_line2d()
	
	# ****************************
	# 画面外判定はMain.gd でやります.
	# ****************************

## Line2Dの座標を更新する
func _update_line2d() -> void:
	for i in range(_line.points.size()-1):
		var a = _line.points[i]
		var b = _line.points[i+1]
		# 0.5の重みで線形補間します
		_line.points[i+1] = b.linear_interpolate(a, 0.5)

func _on_Shot2_area_entered(area: Area2D) -> void:
	vanish()
	if area is Enemy:
		area.hit(get_velocity())
