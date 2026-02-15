extends Node2D

const GAME_OVER_SCENE = preload("res://ui/game_over/game_over.tscn")

enum GameState { RUNNING, PAUSED, GAME_OVER }
var state = GameState.RUNNING

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.new_game_requested.connect(start_new_game)
	Events.lives_changed.connect(func(lives): check_game_over())
	Events.enemy_died.connect(check_game_over)
	Events.enemy_hit_player.connect(death_func)
	Events.enemy_reached_bottom.connect(death_func)

func start_new_game():
	Globals.reset()
	get_tree().paused = false
	get_tree().reload_current_scene()

func check_game_over():
	var enemies = get_tree().get_nodes_in_group("enemy_scout")
	if Globals.lives <= 0 or enemies.size() == 0:
		get_tree().paused = true
		add_child(GAME_OVER_SCENE.instantiate())
		state = GameState.GAME_OVER

func death_func():
	if state != GameState.RUNNING:
		return
	get_tree().paused = true
	add_child(GAME_OVER_SCENE.instantiate())
	state = GameState.GAME_OVER
