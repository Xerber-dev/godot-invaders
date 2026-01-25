extends CharacterBody2D

const BULLET_SCENE = preload("res://elements/bullet/bullet.tscn")

@onready var reload_timer := $ReloadTimer

var reload_delay = 1.0
var speed = 30.0

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		shot()
		
	var direction := Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * speed

	move_and_slide()

func shot():
	if reload_timer.time_left > 0:
		print(reload_timer.time_left)
		return
	var bullet = BULLET_SCENE.instantiate()
	bullet.global_position = global_position + Vector2(0, -15)
	add_child(bullet)
	reload_timer.wait_time = reload_delay
	reload_timer.start()

func take_damage():
	Globals.change_lives(-1)
