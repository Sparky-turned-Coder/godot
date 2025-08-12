extends Label

var score = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	# Below, the second line uses the value of the score variable to replace the placeholder %s. When using this feature, Godot automatically converts values to string text, which is convenient when outputting text in labels or when using the print() function.
func _on_mob_squashed():
	score += 1
	text = "Score: %s" % score
