extends CharacterBody2D

@export var speed = 400
var target = position
@onready var _personatge = $Personatge
@onready var _xerrar = $Personatge/Xerrar
@onready var _pensar = $Personatge/Pensar
@onready var _zona = ""

func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input_direction :
		velocity = input_direction * speed
		target = position
	return input_direction

func _input(event):
	if event.is_action_pressed("click"):
		target = get_global_mouse_position()
	if event.is_action_pressed("ui_accept") && _zona=="Feina":
		_xerrar.text = "treballant"
		habscr.incr


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

func _on_area_feina_body_entered(_body):
	_zona = "Feina"

func _on_area_feina_body_exited(_body):
	_zona = ""

func _on_area_cuina_body_entered(_body):
	_zona = "Cuina"

func _on_area_cuina_body_exited(_body):
	_zona = ""

func _on_area_porta_body_entered(_body):
	_zona = "Porta"

func _on_area_porta_body_exited(_body):
	_zona = ""

func _on_area_oci_body_entered(_body):
	_zona = "Oci"

func _on_area_oci_body_exited(_body):
	_zona = ""

func _on_area_llit_body_entered(_body):
	_zona = "Llit"

func _on_area_llit_body_exited(_body):
	_zona = ""
