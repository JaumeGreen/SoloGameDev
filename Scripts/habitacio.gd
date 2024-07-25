extends Node2D

@export var hour = 8
@export var minutes = 0
@export var date = 17

func increment_time(minuts):
	minutes+=minuts
	format_time()
	
func format_time():
	if minutes>=60 :
		minutes %= 60
		hour+=1
		if hour>=24 :
			hour %= 24
			date+=1
			if date>31 :
				print("game over")

func _on_timer_timeout():
	minutes+=17
	format_time()
	$PasTemps/Calendari.text="%02d"% date
	var hora = "%02d:%02d"
	$PasTemps/Rellotge.text=hora % [hour,minutes]
	$"Items joc/Timer".start(1)
