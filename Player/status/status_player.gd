extends Node
class_name Status

var stat_points = 5
var Vitalidade:int
var Defesa:int
var Forca:int
var Sorte:int
var Inteligencia:int
var XP:int

var selected_class

func set_initial_stats(stats: Array) -> void:
	Vitalidade = stats[0]
	Defesa = stats[1]
	Forca = stats[2]
	Sorte = stats[3]
	Inteligencia = stats[4]
