extends Node2D

@export var hour = 8
@export var minutes = 0
@export var date = 17
@export var paused = false

func increment_time(minuts):
	minutes+=minuts
	format_time()
	
func format_time():
	if minutes>=60 :
		var inchor = minutes/60
		minutes %= 60
		hour+=inchor
		if hour>=24 :
			hour %= 24
			date+=1
			if date>31 :
				print("game over")

func tempsactual():
	return ((date-17)*24+hour)*60+minutes

func show_time():
	$"/root/Habitacio/PasTemps/Calendari".text="%02d"% date
	var hora = "%02d:%02d"
	$"/root/Habitacio/PasTemps/Rellotge".text=hora % [hour,minutes]
	
func _on_timer_timeout():
	minutes+=1
	format_time()
	show_time();
	if date>=31 && hour>=8:
		Global.goto_scene("res://Scripts/perdre.tscn")
	$"/root/Habitacio/Items joc/Tempsjoc".start(1)

func _on_progress_bar_value_changed(value):
	if value>=$ProgressBar.max_value:
		Global.goto_scene("res://Scripts/guanyar.tscn")
		

func _on_sacietat_value_changed(value):
	if value<=0:
		Global.goto_scene("res://Scripts/perdre.tscn")


func _on_pausa_pressed():
	paused = !paused
	$"/root/Habitacio/Items joc/Tempsjoc".paused=paused
	if paused:
		$Xerrar.text="Paused"
	else:
		$Xerrar.text=""
