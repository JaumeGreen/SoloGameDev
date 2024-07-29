extends Node2D


func _on_button_pressed():
	Global.goto_scene("res://Scripts/menu.tscn")

func _input(event):
	if event.is_action_pressed("ui_accept"):
		Global.goto_scene("res://Scripts/menu.tscn")
