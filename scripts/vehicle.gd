extends Area2D

@export var speed := 50.0
@export var direction := 1.0

const SCREEN_WIDTH := 320
const VEHICLE_WIDTH := 24

func _process(delta: float) -> void:
	position.x += speed * direction * delta
	
	if direction > 0 and position.x > SCREEN_WIDTH + VEHICLE_WIDTH:
		position.x = -VEHICLE_WIDTH
		
	elif direction < 0 and position.x < -VEHICLE_WIDTH:
		position.x = SCREEN_WIDTH + VEHICLE_WIDTH


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.name == "Player":
		body.die()
