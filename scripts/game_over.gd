extends Panel
func _ready():
	$fade_in_out.play('fade')

func play_tone():
	$tone.play()

func _on_fade_in_out_animation_finished(anim_name):
	if anim_name == 'fade':
		get_tree().change_scene('res://scenes/game.tscn')
