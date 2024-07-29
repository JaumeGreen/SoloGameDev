extends CharacterBody2D

@export var speed = 400
var target = position
@onready var _personatge = $Personatge
@onready var _xerrar = $Personatge/Xerrar
@onready var _pensar = $Personatge/Pensar
@onready var _zona = ""
@onready var _hab = $"/root/Habitacio"
@onready var _tempsjoc = $"/root/Habitacio/Items joc/Tempsjoc"
@onready var _progres = $"/root/Habitacio/ProgressBar"
@onready var _energia=$/root/Habitacio/Barres/Energy
@onready var _voluntat=$/root/Habitacio/Barres/Forçavoluntat
@onready var _sacietat=$/root/Habitacio/Barres/Sacietat
@onready var _sociabilitat=$/root/Habitacio/Barres/Sociabilitat
@onready var _accions = { #localització : [temps, progress, energia, voluntat, saciabilitat, sociabilitat]
	"Feina" : [[60,1,-10,-5,-6,-4],[60,0,-10,-10,-6,-4],[30,0,-5,-5,-3,-2]],
	"Llit" : [[480,0,80,70,-30,-20],[60,0,20,10,-6,-4],[30,0,0,0,-3,-2]],
	"Cuina" : [[60,0,20,-5,40,-4],[30,0,30,-10,20,-4],[60,0,-10,15,-3,-2]],
	"Porta" : [[120,0,-10,5,0,50],[60,0,-10,10,-12,0],[30,0,5,5,-3,-2]],
	"Oci" : [[60,0,-10,5,-6,20],[60,0,-10,-10,-6,-4],[60,0,-5,-5,-3,-2]],
}
@onready var _accionsText = {
	"Feina" : ["Action 1\nWork on the game\nGain progress\nLose energy", "Action 2\nTutorial\nGain knowledge\nLose energy", "Action 3\nPlan\nImprove growth"],
	"Llit" : ["Action 1\nSleep\nGain energy\nLose time", "Action 2\nRest\nGain little energy\nLose little time", "Action 3\nMeditate\nImprove willpower\nMental relaxation"],
	"Cuina" : ["Action 1\nEat\nGain saciety", "Action 2\nSugar bomb\nGain energy\nUnhealthy", "Action 3\nMeal prep\nFaster eating\nMental relaxation"],
	"Oci" : ["Action 1\nGame friends\nGain sociability\nGain willpower", "Action 2\nHard game\nImprove willpower\nLose time", "Action 3\nTimewaster\nMental relaxation"],
	"Porta" : ["Action 1\nFriends' outing\nGain sociability\nLose time", "Action 2\nGym\nImprove body\nLose time", "Action 3\nWalk\nMental relaxation"],
	"" : ["Action 1\nGo to any item\nto enable this", "Action 2\nGo to any item\nto enable this", "Action 3\nGo to any item\nto enable this"],
}
@onready var knowledge = 1.0
@onready var mealprep = 1.0
@onready var gymbuddies = 0

func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input_direction :
		velocity = input_direction * speed
		target = position
	return input_direction

func specialaction1():
	pass

func specialaction2():
	if _zona=="Feina":
		knowledge+0.1
	if _zona=="Cuina":
		_energia.max_value -= 5
	if _zona=="Oci":
		_voluntat.max_value +=5
	if _zona=="Porta":
		_energia.max_value += 5
		_voluntat.max_value +=5
		_sociabilitat.value += gymbuddies *5
		if gymbuddies<10 :
			gymbuddies+=1
		
func specialaction3():
	if _zona=="Feina":
		_progres.max_value -= int(1*knowledge*knowledge)
	if _zona=="Llit":
		_voluntat.max_value += 5
	if _zona=="Cuina" && mealprep>0.2:
		mealprep-=0.1

func acciotriga(minuts) : 
	if _energia.value<30 :
		minuts *= 1.1
	if _voluntat.value<30 :
		minuts *= 1.1
	if _sacietat.value<30 :
		minuts *= 1.1
	if _sociabilitat.value<30 :
		minuts *= 1.1
	if _zona=="Cuina":
		minuts *= mealprep
	_tempsjoc.stop()
	_hab.increment_time(int(minuts))
	_hab.show_time()
	_tempsjoc.start(1)

func progres(percentatge) : 
	if _energia.value<30 :
		percentatge *= 0.5
	if _voluntat.value<30 :
		percentatge *= 0.75
	if _sacietat.value<30 :
		percentatge *= 0.8
	if _sociabilitat.value<30 :
		percentatge *= 0.9
	_progres.value+=int(percentatge*knowledge)
func energia(canvi) : 
	_energia.value+=canvi
func voluntat(canvi) : 
	_voluntat.value+=canvi
func sacietat(canvi) : 
	_sacietat.value+=canvi
func sociabilitat(canvi) : 
	_sociabilitat.value+=canvi

func _unhandled_input(event):
	if event.is_action_pressed("click"):
		target = get_global_mouse_position()
	if event.is_action_pressed("acte1") && _zona!="":
		acciotriga(_accions[_zona][0][0])
		progres(_accions[_zona][0][1])
		energia(_accions[_zona][0][2])
		voluntat(_accions[_zona][0][3])
		sacietat(_accions[_zona][0][4])
		sociabilitat(_accions[_zona][0][5])
		specialaction1()
	if event.is_action_pressed("acte2") && _zona!="":
		acciotriga(_accions[_zona][1][0])
		progres(_accions[_zona][1][1])
		energia(_accions[_zona][1][2])
		voluntat(_accions[_zona][1][3])
		sacietat(_accions[_zona][1][4])
		sociabilitat(_accions[_zona][1][5])
		specialaction2()
	if event.is_action_pressed("acte3") && _zona!="":
		acciotriga(_accions[_zona][2][0])
		progres(_accions[_zona][2][1])
		energia(_accions[_zona][2][2])
		voluntat(_accions[_zona][2][3])
		sacietat(_accions[_zona][2][4])
		sociabilitat(_accions[_zona][2][5])
		specialaction3()



func look_direction(dir):
	if dir.x < -0.4 && dir.y < -0.4 :
		_personatge.play("NW")
	if dir.x < -0.4 && dir.y > 0.4 :
		_personatge.play("SW")
	if dir.x < -0.4 && dir.y >-0.4 && dir.y < 0.4 :
		_personatge.play("W")
	if dir.x > 0.4 && dir.y < -0.4 :
		_personatge.play("NE")
	if dir.x > 0.4 && dir.y > 0.4 :
		_personatge.play("SE")
	if dir.x > 0.4 && dir.y >-0.4 && dir.y < 0.4 :
		_personatge.play("E")
	if dir.x < 0.4 && dir.x > -0.4 && dir.y < -0.4 :
		_personatge.play("N")
	if dir.x < 0.4 && dir.x > -0.4 && dir.y > 0.4 :
		_personatge.play("S")


func _physics_process(_delta):
	var dir = position.direction_to(target)
	velocity = dir * speed
	var dir2 = get_input()
	if position.distance_to(target) > 10 :
		var prevpos = position
		look_direction(dir)
		move_and_slide()
		if position.distance_to(prevpos)<1:
			target = position
	elif dir2 :
		look_direction(dir2)
		move_and_slide()
	else :
		_personatge.play("SStill")

func _setactionstext(disabled):
	$/root/Habitacio/Accions/Accio1.set_text(_accionsText[_zona][0])
	$/root/Habitacio/Accions/Accio2.set_text(_accionsText[_zona][1])
	$/root/Habitacio/Accions/Accio3.set_text(_accionsText[_zona][2])
	$/root/Habitacio/Accions/Accio1.disabled = disabled
	$/root/Habitacio/Accions/Accio2.disabled = disabled
	$/root/Habitacio/Accions/Accio3.disabled = disabled

func _on_area_feina_body_entered(_body):
	_zona = "Feina"
	_setactionstext(false)

func _on_area_feina_body_exited(_body):
	if _zona=="Feina" :
		_zona = ""
		_setactionstext(true)

func _on_area_cuina_body_entered(_body):
	_zona = "Cuina"
	_setactionstext(false)

func _on_area_cuina_body_exited(_body):
	if _zona=="Cuina" :
		_zona = ""
		_setactionstext(true)

func _on_area_porta_body_entered(_body):
	_zona = "Porta"
	_setactionstext(false)

func _on_area_porta_body_exited(_body):
	if _zona=="Porta" :
		_zona = ""
		_setactionstext(true)

func _on_area_oci_body_entered(_body):
	_zona = "Oci"
	_setactionstext(false)

func _on_area_oci_body_exited(_body):
	if _zona=="Oci" :
		_zona = ""
		_setactionstext(true)

func _on_area_llit_body_entered(_body):
	_zona = "Llit"
	_setactionstext(false)

func _on_area_llit_body_exited(_body):
	if _zona=="Llit" :
		_zona = ""
		_setactionstext(true)


func _on_accio_1_pressed():
	if _zona!="":
		acciotriga(_accions[_zona][0][0])
		progres(_accions[_zona][0][1])
		energia(_accions[_zona][0][2])
		voluntat(_accions[_zona][0][3])
		sacietat(_accions[_zona][0][4])
		sociabilitat(_accions[_zona][0][5])
		specialaction1()


func _on_accio_2_pressed():
	if _zona!="":
		acciotriga(_accions[_zona][1][0])
		progres(_accions[_zona][1][1])
		energia(_accions[_zona][1][2])
		voluntat(_accions[_zona][1][3])
		sacietat(_accions[_zona][1][4])
		sociabilitat(_accions[_zona][1][5])
		specialaction2()

func _on_accio_3_pressed():
	if _zona!="":
		acciotriga(_accions[_zona][2][0])
		progres(_accions[_zona][2][1])
		energia(_accions[_zona][2][2])
		voluntat(_accions[_zona][2][3])
		sacietat(_accions[_zona][2][4])
		sociabilitat(_accions[_zona][2][5])
		specialaction3()
