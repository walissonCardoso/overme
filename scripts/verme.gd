extends KinematicBody2D

export (int) var SPEED = 50

var pink = Color(0.4, 0.1, 0.2)
var lighterPink = Color(0.81, 0.21, 0.38)

var velocity = Vector2(0, -1)
var size = 20
var thickness = 5
var incSize = 0
onready var turns = [Vector2(position.x, position.y)]

func _ready():
	add_to_group('PLAYER')
	$shape.scale.x = thickness
	$shape.scale.y = thickness
	
	get_tree().paused = true

func _input(event):
	var oldVelocity = copy2(velocity)
	if event.is_action_pressed("ui_right"):
		velocity = Vector2(1, 0)
	if event.is_action_pressed("ui_left"):
		velocity = Vector2(-1, 0)
	if event.is_action_pressed("ui_up"):
		velocity = Vector2(0, -1)
	if event.is_action_pressed("ui_down"):
		velocity = Vector2(0, 1)
		
	if velocity + oldVelocity == Vector2.ZERO or velocity == oldVelocity:
		velocity = copy2(oldVelocity)
	else:
		turns.append(copy2(position))

func _physics_process(delta):
	if incSize > 0:
		incSize -= delta * 40
		size += delta * 40
	
	if size > 1:
		size -= delta * 0.2
		thickness -= delta * 0.005
		
		size = max(1, size)
		thickness = max(1, thickness)
		
	# warning-ignore:return_value_discarded
	move_and_collide(velocity * SPEED * delta)
	update()

func increase():
	incSize += 40
	thickness += 0.3

func _draw():
	draw_snake(thickness, pink)
	draw_snake(thickness-2, lighterPink)

func draw_snake(_thickness, _color):
	draw_circle(Vector2.ZERO, _thickness, _color)
	
	var size_re = size
	var origin = Vector2.ZERO
	for i in range(len(turns)-1, -1, -1):
		if size_re <= 0:
			turns.remove(i)
			break
		
		var pos = to_global(copy2(turns[i]))
		var distance = mahalanobis(pos, origin)
		
		if distance > size_re:
			pos.x = clamp(pos.x, origin.x - size_re, origin.x + size_re)
			pos.y = clamp(pos.y, origin.y - size_re, origin.y + size_re)
			
		draw_line(origin, pos, _color, _thickness * 2)
		draw_circle(pos, _thickness, _color)
		
		origin = copy2(pos)
		size_re -= distance
	
func mahalanobis(vec1, vec2):
	return abs(vec2.x - vec1.x) + abs(vec2.y - vec1.y)

func to_global(pos):
	return pos - position

func copy2(vector):
	return Vector2(vector.x, vector.y)

func _on_Button_pressed():
	get_tree().paused = false
	$HUD/startPanel.hide()

func zoomout():
	$animation.play('zoomout')

func _on_narration_finished():
	zoomout()
	$tense.play()

func _on_animation_finished(anim_name):
	if anim_name == 'zoomout':
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://scenes/game_over.tscn")
