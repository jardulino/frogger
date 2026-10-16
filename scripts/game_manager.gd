extends Node

signal lives_changed(lives: int)
signal game_over

@export var starting_lives := 3
@export var respawn_delay := 1.0

var lives: int
var game_state := "playing" ## playing/dead/game_over/paused/level_complete

@onready var player = get_parent().get_node("Level/Player")
@onready var lives_label = get_parent().get_node("HUD/LivesLabel")
@onready var game_over_label = get_parent().get_node("HUD/GameOverLabel")


func _ready() -> void:
	lives = starting_lives
	lives_changed.connect(_on_lives_changed)
	
	_on_lives_changed(lives)
	
	player.died.connect(_on_player_died)

func _on_lives_changed(value: int) -> void:
	lives_label.text = "Lives: %d" % value

func _on_player_died() -> void:
	if game_state != "playing":
		return

	game_state = "dead"

	lives -= 1
	lives_changed.emit(lives)

	if lives <= 0:
		_handle_game_over()
		return

	await get_tree().create_timer(respawn_delay).timeout

	if game_state == "dead":
		await player.respawn()
		game_state = "playing"


func _handle_game_over() -> void:
	game_state = "game_over"
	game_over_label.visible = true
	game_over.emit()
