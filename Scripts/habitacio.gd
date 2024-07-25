extends Node2D

@onready var _xerrar = $Soloer/Personatge/Xerrar
@onready var _pensar = $Soloer/Personatge/Pensar


func _on_area_feina_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("ui_accept"):
		_xerrar.text = "treballant"

func _on_area_feina_body_entered(body):
	_pensar.text = "res no funciona..."


func _on_area_feina_body_exited(body):
	_pensar.text = ""
