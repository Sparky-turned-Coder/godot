extends Node

@export var mob_scene: PackedScene

func _ready():
	$UserInterface/Retry.hide()
	
# Let's code the mob spawning logic. We're going to:
# 1.  Instantiate the mob scene.
# 2.  Sample a random position on the spawn path.
# 3.  Get the player's position.
# 4.  Call the mob's initialize() method, passing it the random position and the player's position.
# 5.  Add the mob as a child of the Main node.
func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()
	
	# Choose a random location on the SpawnPath
	# We store the reference to the SpawnLocation node.
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	# And give it a random offset.
	mob_spawn_location.progress_ratio = randf()
	
	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position, player_position)
	
	# Spawn the mob by adding it to the Main Scene.
	add_child(mob)
	
	# We connect the mob to the score label to update the score upon squashing one.
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())
	
	# Above, randf() produces a random value between 0 and 1, which is what the PathFollow node's progress_ratio expects: 0 is the start of the path, 1 is the end of the path. The path we have set is around the camera's viewport, so any random value between 0 and 1 is a random position alongside the edges of the viewport!

func _on_player_hit():
	$MobTimer.stop()
	$UserInterface/Retry.show()
	
func _unhandled_input(event):
	if event.is_action_pressed("retry") and $UserInterface/Retry.visible:
		# This restarts the current scene.
		get_tree().reload_current_scene()
