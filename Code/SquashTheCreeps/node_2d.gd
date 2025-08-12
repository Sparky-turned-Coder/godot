extends Node2D

var visual_pos = Vector2.ZERO
var physics_pos = Vector2.ZERO
var speed = 200  # pixels per second

func _ready():
	visual_pos = Vector2(100, 100)
	physics_pos = Vector2(100, 200)

func _process(delta):
	# Visual movement (render frame rate)
	visual_pos.x += speed * delta

func _physics_process(delta):
	# Physics movement (fixed time step)
	physics_pos.x += speed * delta

func _draw():
	# Red circle = moved in _process()
	draw_circle(visual_pos, 10, Color.RED)
	# Blue circle = moved in _physics_process()
	draw_circle(physics_pos, 10, Color.BLUE)
