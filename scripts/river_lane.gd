extends Node2D

@export var speed := 40.0
@export var direction := 1.0
@export var log_count := 2

const SCREEN_WIDTH := 320
const LOG_SPACING := 140.0

const LOG_SCENE := preload("res://scenes/Log.tscn")


func _ready() -> void:
	spawn_logs()


func spawn_logs() -> void:
	for i in log_count:
		var log := LOG_SCENE.instantiate()
		var logPosition := i * LOG_SPACING

		log.speed = speed
		log.direction = direction

		if direction > 0:
			log.position.x = logPosition
		else:
			log.position.x = SCREEN_WIDTH - logPosition

		add_child(log)
