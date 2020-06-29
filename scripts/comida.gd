extends Area2D

onready var game_size = Vector2(ProjectSettings.get_setting('display/window/size/width'),
								ProjectSettings.get_setting('display/window/size/height'))

onready var space_state = get_world_2d().direct_space_state

func _ready():
	add_to_group('FOOD')
	$glow.play('glow')
	random_pos()

func random_pos():
	position.x = rand_range(0, game_size.x)
	position.y = rand_range(0, game_size.y)
	
	if space_state.intersect_point(position) != []:
		random_pos()

func _on_comida_body_entered(body):
	if body.is_in_group('PLAYER'):
		body.increase()
		random_pos()
