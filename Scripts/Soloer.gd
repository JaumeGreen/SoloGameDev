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
	"Feina" : [30,40,-5,-5,-3,-2],
	"Llit" : [480,0,50,40,-20,-10],
	"Cuina" : [60,0,10,5,50,-1],
	"Porta" : [120,0,-5,0,0,50],
	"Oci" : [60,0,-10,30,-5,-5],
}
@onready var _accionsText = {
	"Feina" : ["Action 1\nWork on the game\nGain progress\nLose energy", "Action 2\nTutorial\nGain knowledge\nLose energy", "Action 3\nPlan\nBetter future progress\nLose energy"],
	"Llit" : ["Action 1\nSleep\nGain energy\nLose time", "Action 2\nRest\nGain little energy\nLose little time", "Action 3\nMeditate\nImprove willpower\nLose time"],
	"Cuina" : ["Action 1\nEat\nGain saciety", "Action 2\nSugar+caffeine\nGain energy\nBad for your body", "Action 3\nPrepare future meal\nFaster meals for a while\nMental relaxation"],
	"Porta" : ["Action 1\nFriends' outing\nGain sociability\nLose time", "Action 2\nGym\nImprove body\nLose time", "Action 3\nWalk\nMental relaxation"],
	"Oci" : ["Action 1\nGame with friends\nGain sociability\nGain willpower", "Action 2\nHard solo game\nGain willpower\nLose time", "Action 3\nWatch series/browse sites\nMental relaxation"],
	"" : ["Action 1\nGo to any item\nto enable this", "Action 2\nGo to any item\nto enable this", "Action 3\nGo to any item\nto enable this"],
}

func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input_direction :
		velocity = input_direction * speed
		target = position
	return input_direction

func acciotriga(minuts) : 
	_tempsjoc.stop()
	_hab.increment_time(minuts)
	_hab.show_time()
	_tempsjoc.start(1)

func progres(percentatge) : 
	_progres.value+=percentatge
func energia(canvi) : 
	_energia.value+=canvi
func voluntat(canvi) : 
	_voluntat.value+=canvi
func sacietat(canvi) : 
	_sacietat.value+=canvi
func sociabilitat(canvi) : 
	_sociabilitat.value+=canvi

func _input(event):
	if event.is_action_pressed("click"):
		target = get_global_mouse_position()
	if event.is_action_pressed("ui_accept") && _zona!="":
		acciotriga(_accions[_zona][0])
		progres(_accions[_zona][1])
		energia(_accions[_zona][2])
		voluntat(_accions[_zona][3])
		sacietat(_accions[_zona][4])
		sociabilitat(_accions[_zona][5])



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
		look_direction(dir)
		move_and_slide()
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
