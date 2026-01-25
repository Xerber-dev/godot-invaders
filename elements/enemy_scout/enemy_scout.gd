extends CharacterBody2D
const DESTROY_SCENE = preload("res://elements/enemy_scout_destroy/enemy_scout_destroy.tscn")
const ENEMY_BULLET_SCENE = preload("res://elements/enemy_bullet/enemy_bullet.tscn")
#const ANIM_ENEMY_BULLET_SCENE = preload("res://elements/anim_scout_bullet/anim_scout_bullet.tscn")

@onready var raycast_left := $RayCastLeft
@onready var raycast_right := $RayCastRight


func _physics_process(delta: float) -> void:
	if raycast_left.is_colliding() or raycast_right.is_colliding():
		get_tree().call_group("enemy_scout_group", "change_direction")

func destroy():
	Globals.change_points(1)
	# Создаем взрыв на той же сцене
	var destroy_instance = DESTROY_SCENE.instantiate()
	get_tree().current_scene.add_child(destroy_instance)
	destroy_instance.global_position = global_position
	
	# Удаляем корабль
	queue_free()
	
	Events.enemy_died.emit()

func shot():
	#var anim_bullet = ANIM_ENEMY_BULLET_SCENE.instantiate()
	#get_tree().current_scene.add_child(anim_bullet)
	#anim_bullet.global_position = global_position
	var bullet = ENEMY_BULLET_SCENE.instantiate()
	bullet.global_position += global_position + Vector2(0, 10.0)
	add_child(bullet)
