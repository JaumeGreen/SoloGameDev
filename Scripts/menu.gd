extends Node2D


func _on_jugar_pressed():
		get_node("/root/global").goto_scene("res://Scripts/habitacio.tscn")
