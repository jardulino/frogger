extends CharacterBody2D

signal died

const TILE_SIZE:int = 16
const START_POSITION:Vector2 = Vector2(160,152)
const MAX_WIDTH:int = 320
const MAX_HEIGHT:int = 180
const RIVER_TOP:int = 16
const RIVER_BOTTOM:int = 64
const LOG_WIDTH:int = 80

enum PlayerState {
	ALIVE,
	DYING,
	DEAD,
	RESPAWNING
}

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var state:PlayerState = PlayerState.ALIVE
var current_log: AnimatableBody2D = null

func _ready() -> void:
	animation_player.play("RESET")

func _unhandled_input(event: InputEvent) -> void:
	if state != PlayerState.ALIVE:
		return
		
	if event.is_action_pressed("move_up"):
		move_player(Vector2.UP)

	elif event.is_action_pressed("move_down"):
		move_player(Vector2.DOWN)

	elif event.is_action_pressed("move_left"):
		move_player(Vector2.LEFT)

	elif event.is_action_pressed("move_right"):
		move_player(Vector2.RIGHT)


func move_player(direction: Vector2) -> void:
	var new_position := position + direction * TILE_SIZE

	new_position.x = clamp(new_position.x, TILE_SIZE / 2.0, MAX_WIDTH - TILE_SIZE / 2.0)
	new_position.y = clamp(new_position.y, TILE_SIZE / 2.0, MAX_HEIGHT - TILE_SIZE / 2.0)

	position = new_position
	
	await get_tree().physics_frame
	await get_tree().physics_frame
	
	check_river()
	
#func check_river() -> void:
	#var y := global_position.y
	#
	#if y >= RIVER_TOP and y < RIVER_BOTTOM:
		#return
		#
	#var logs = $LogDetector.get_overlapping_bodies()
	#
	#for body in logs:
		#if body.is_in_group("log"):
			#current_log = body
			#return
	#
	#current_log = null
	#die()
	
func check_river() -> void:
	var y := global_position.y

	if y < RIVER_TOP or y >= RIVER_BOTTOM:
		current_log = null
		return
		
	if current_log == null:
		die()

func die() -> void:
	print("!!! PLAYER DIE CALLED !!!")
	print("Position local: ", position)
	print("Position global: ", global_position)
	print("Current log: ", current_log)
	
	if state != PlayerState.ALIVE:
		return

	state = PlayerState.DYING
	died.emit()
	animation_player.play("death")
	await animation_player.animation_finished
	state = PlayerState.DEAD
	
func respawn() -> void:
	position = START_POSITION
	state = PlayerState.RESPAWNING
	animation_player.play("respawn")
	await animation_player.animation_finished
	state = PlayerState.ALIVE
	

func _physics_process(delta: float) -> void:
	if state != PlayerState.ALIVE:
		return
		
	if current_log != null:
		position.x += current_log.speed * current_log.direction * delta
		
		if position.x > MAX_WIDTH: #position.x > 0 or position.x > MAX_WIDTH + LOG_WIDTH:
			position.x = -LOG_WIDTH
		
		if position.x < 0: #or position.x > MAX_WIDTH:
			die()

func _on_log_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("logs"):
		current_log = body


func _on_log_detector_body_exited(body: Node2D) -> void:
	if body == current_log:
		current_log = null
