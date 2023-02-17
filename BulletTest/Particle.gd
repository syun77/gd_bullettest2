extends Sprite

var _timer := 0.0
var _timer_max := 1.0
var _velocity = Vector2()
var _decay = 0.98

func start(t:float, deg:float, speed:float) -> void:
	_timer_max = t * rand_range(0.5, 1.5)
	var rad = deg2rad(deg)
	_velocity.x = cos(rad) * speed
	_velocity.y = -sin(rad) * speed
	_decay = rand_range(0.9, 0.98)

func _physics_process(delta: float) -> void:
	#delta *= Common.get_hitslow_rate()
	_timer += delta
	if _timer >= _timer_max:
		queue_free()
		return
	
	_velocity *= _decay
	position += _velocity * delta
	var rate = 1.0 - (_timer / _timer_max)
	var sc = rate * 0.5
	scale = Vector2(sc, sc)
	modulate.a = rate * 0.5
