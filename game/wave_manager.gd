extends Node2D

@onready var spawn_timer := $SpawnTimer
@onready var shot_timer := $ShotTimer

var current_wave := 1
var enemies_alive := 0
var remaining_enemies := 0
var boss_alive := false
var available_points := []
var available_enemies := []

var waves = {
  1: {"available_enemies": ["Scout"], "hp_multiplier": 1.5, "boss": false},
  2: {"available_enemies": ["Scout"], "hp_multiplier": 2, "boss": false},
  3: {"available_enemies": ["Scout"], "hp_multiplier": 2.5, "boss": false},
  4: {"available_enemies": ["Scout"], "hp_multiplier": 3, "boss": false},
  5: {"available_enemies": ["Scout"], "hp_multiplier": 3.5, "boss": false},
  6: {"available_enemies": ["BossScout"], "hp_multiplier": 1.0, "boss": true}
}

var enemies = {
	"Scout": preload("res://elements/enemy_scout/enemy_scout.tscn")
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.enemy_died.connect(func(): check_end_wave())
	
	var spawnpoints = get_node("SpawnPoints").get_child_count()
	var spawn_points := []
	for spawnpoint in range(spawnpoints):
		var spawn_point: Node2D = get_node("SpawnPoints").get_child(spawnpoint)
		spawn_points.append(spawn_point.global_position)
	
	start_wave(spawnpoints,spawn_points)

func start_wave(spawnpoints,spawn_points):
	var wave_info = get_current_wave_data()
	if wave_info["boss"] == false:
		enemies_alive = spawnpoints
		remaining_enemies = spawnpoints
	else:
		boss_alive = true
	
	available_enemies = wave_info["available_enemies"]
	available_points = spawn_points.duplicate()

func get_current_wave_data():
	var wave_info = waves[current_wave]
	return wave_info

func check_end_wave():
	print("Враг убит")
	if boss_alive == true:
		print("Волна завершена. Босс убит")
		boss_alive = false
	else:
		enemies_alive -= 1
		print("Осталось " + str(enemies_alive))
		if enemies_alive == 0:
			print("Волна завершена. Врагов нет")

func _on_spawn_timer_timeout() -> void:
	if remaining_enemies > 0:
		var position = available_points[0]
		var enemy = available_enemies.pick_random()
		var enemy_scene = enemies[enemy]
		enemy_scene = enemy_scene.instantiate()
		enemy_scene.global_position = position
		get_tree().current_scene.add_child(enemy_scene)
		print("spawn ",enemy," at ", position)
		available_points.erase(position)
		remaining_enemies -= 1
	else:
		spawn_timer.stop()

func _on_shot_timer_timeout() -> void:
	var enemies = get_tree().get_nodes_in_group("enemy_scout")
	if enemies.size() > 0:
		enemies.pick_random().shot()
