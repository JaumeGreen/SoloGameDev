extends CharacterBody2D

@export var speed = 400
var target = position
@onready var _personatge = $Personatge

func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * speed

func _input(event):
	if event.is_action_pressed("click"):
		target = get_global_mouse_position()

func _physics_process(_delta):
	#get_input()
	var dir = position.direction_to(target)
	velocity = dir * speed
	if position.distance_to(target) > 10:
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
		move_and_slide()
	else :
		_personatge.play("SStill")

