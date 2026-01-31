extends CharacterBody2D
const DESTROY_SCENE = preload("res://elements/enemy_scout_destroy/enemy_scout_destroy.tscn")
const ENEMY_BULLET_SCENE = preload("res://elements/enemy_bullet/enemy_bullet.tscn")
const ROW_STEP = 3.0
const SPEED_BOOST := 1.5

@onready var raycast_left := $RayCastLeft
@onready var raycast_right := $RayCastRight
@onready var block_timer := $BlockTimer


var direction := Vector2.RIGHT
var speed := 5.0

func _physics_process(delta: float) -> void:
	if raycast_left.is_colliding() or raycast_right.is_colliding():
		get_tree().call_group("enemy_scout", "change_direction")
		
	global_position += direction * speed * delta

func change_direction():
	if block_timer.time_left > 0:
		return
	direction = Vector2.LEFT if direction == Vector2.RIGHT else Vector2.RIGHT
	global_position.y += ROW_STEP
	speed += SPEED_BOOST
	block_timer.start()


func destroy():
	Globals.change_points(1)
	var destroy_instance = DESTROY_SCENE.instantiate()
	get_tree().current_scene.add_child(destroy_instance)
	destroy_instance.global_position = global_position
	queue_free()
	
	Events.enemy_died.emit()

func shot():
	var bullet = ENEMY_BULLET_SCENE.instantiate()
	bullet.global_position += global_position + Vector2(0, 10.0)
	add_child(bullet)
