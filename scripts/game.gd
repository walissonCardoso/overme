extends Node2D

const fabrica_comida = preload("res://scenes/comida.tscn")

func _ready():
	for _i in range(20):
		add_child(fabrica_comida.instance())
