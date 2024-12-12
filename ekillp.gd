extends CharacterBody2D

var speed = 40
var player_chase = false
var player = null 

func _physics_process(delta: float) -> void:
	if player_chase:
		# Calculate direction to the player and normalize the vector
		var direction = (player.position - position).normalized()
		# Set the velocity towards the player
		velocity = direction * speed
		# Move the enemy and handle collisions
		move_and_slide()

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true
	# Check if the enemy collides with the player
	if body.is_in_group("player"):
		print("You Died")
		# Restart the game by reloading the current scene
		get_tree().reload_current_scene()

func _on_detection_area_body_exited(body):
	player = null
	player_chase = false
-- enemy kills player when collided
