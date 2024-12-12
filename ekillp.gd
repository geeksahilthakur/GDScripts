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

		# Check for collisions after moving
		for i in range(get_slide_collision_count()):
			var collision = get_slide_collision(i)
			# Use get_collider() to access the collided object
			if collision.get_collider().is_in_group("player"):
				print("You Died")
				# Ensure get_tree() is valid before reloading
				var tree = get_tree()
				if tree:
					tree.reload_current_scene()

func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		player = body
		player_chase = true

func _on_detection_area_body_exited(body):
	if body.is_in_group("player"):
		player = null
		player_chase = false
