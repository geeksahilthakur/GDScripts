extends RigidBody2D

@export var explosion_radius: float = 100  # Radius of the explosion
@export var damage: int = 50  # Damage applied to enemies within the explosion radius

var explosion_area: Area2D  # Reference to the Area2D node for explosion detection
var sprite: Sprite2D  # Reference to the Sprite2D for the visual representation of the bomb

# This function will run when the bomb is planted
func _ready():
	explosion_area = $ExplosionArea  # Manually assign Area2D node
	sprite = $BombSprite  # Manually assign Sprite2D node

	# Disable gravity for the bomb
	gravity_scale = 0  # Disable gravity for this RigidBody2D

	# Debugging print statement
	print("Bomb planted at position:", position)

	# Call the function to wait for 3 seconds and explode
	_start_explosion_timer()

# Function to handle the explosion after delay
func _start_explosion_timer():
	var timer = Timer.new()
	timer.wait_time = 3  # Set the delay (3 seconds)
	timer.one_shot = true  # Make the timer a one-shot timer
	timer.connect("timeout", Callable(self, "_on_explosion"))
	add_child(timer)  # Add timer to the bomb as a child
	timer.start()  # Start the timer

# This function is called when the timer times out (after 3 seconds)
func _on_explosion():
	print("Bomb exploded!")  # Debugging print statement

	# Detect overlapping bodies in the Area2D when the bomb explodes
	var enemies_in_range = explosion_area.get_overlapping_bodies()  # Get all overlapping bodies
	for body in enemies_in_range:
		if body.is_in_group("enemy"):  # Check if the body is an enemy
			print("Enemy within range, applying damage.")  # Debugging print statement
			body.queue_free()  # Immediately remove the enemy (no health logic, instant death)
		elif body.is_in_group("player"):  # Check if the body is the player
			print("Player within range, applying damage.")  # Debugging print statement
			body.queue_free()  # Immediately remove the player (no health logic, instant death)
			# Restart the game if player is killed
			get_tree().reload_current_scene()

	# Optionally, play explosion effect here (sound, animation, etc.)
	queue_free()  # Removes the bomb from the scene after it explodes
	print("Bomb removed from scene.")  # Debugging print statement
