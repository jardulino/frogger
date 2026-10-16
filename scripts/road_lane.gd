extends Node2D

@export_category("Lane")

@export var speed := 50.0
@export_range(-1, 1, 1) var direction := 1.0
@export_range(1,6) var vehicle_count := 2

const SCREEN_WIDTH := 320
const VEHICLE_WIDTH := 24
const VEHICLE_SPACING := 120.0

const VEHICLE_SCENE := preload("res://scenes/Vehicle.tscn")


func _ready() -> void:
	spawn_vehicles()


func spawn_vehicles() -> void:
	for i in vehicle_count:
		var vehicle := VEHICLE_SCENE.instantiate()

		vehicle.speed = speed
		vehicle.direction = direction
		
		var RANDOM_POSITION = i * VEHICLE_SPACING ## + randf_range(-20, 20)

		if direction > 0:
			vehicle.position.x = RANDOM_POSITION
		else:
			vehicle.position.x = SCREEN_WIDTH - RANDOM_POSITION

		add_child(vehicle)
