


#The script is about enemy ai scriptau where enemy is using area 2D node for the detection and at changes the player for that you just need to create a group to your player which says which has a label player basically and when an image collides changes and collides with the player it prints you died on the terminal window and also a tree starts the scene 

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
