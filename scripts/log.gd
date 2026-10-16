extends AnimatableBody2D

@export var speed := 40.0
@export var direction := 1.0

const SCREEN_WIDTH := 320
const LOG_WIDTH := 80.0

func _physics_process(delta: float) -> void:
	position.x += speed * direction * delta

	if direction > 0 and position.x > SCREEN_WIDTH + LOG_WIDTH:
		position.x = -LOG_WIDTH

	elif direction < 0 and position.x < -LOG_WIDTH:
		position.x = SCREEN_WIDTH + LOG_WIDTH
