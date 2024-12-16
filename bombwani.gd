extends RigidBody2D

@export var explosion_radius: float = 100  # Radius of the explosion
@export var damage: int = 50  # Damage applied to enemies within the explosion radius

var explosion_area: Area2D  # Reference to the Area2D node for explosion detection
var animated_sprite: AnimatedSprite2D  # Reference to the AnimatedSprite2D for animations
var timer: Timer  # Reference to the timer for the explosion delay

# This function will run when the bomb is planted
func _ready():
	explosion_area = $ExplosionArea  # Manually assign Area2D node
	animated_sprite = $BombSprite  # Manually assign AnimatedSprite2D node
	timer = Timer.new()  # Create a new timer

	# Disable gravity for the bomb
	gravity_scale = 0  # Disable gravity for this RigidBody2D

	# Play the idle animation when the bomb is planted
	animated_sprite.play("idle")

	# Debugging print statement
	print("Bomb planted at position:", position)

	# Add the timer to the bomb as a child
	add_child(timer)

	# Set up the timer properties
	timer.wait_time = 3  # Wait for 3 seconds before explosion
	timer.one_shot = true  # Timer will only fire once
	timer.start()  # Start the timer

	# Connect the timer's timeout signal to the _on_explosion function
	timer.timeout.connect(self._on_explosion)  # Call _on_explosion once timer finishes

# This function is called when the timer times out (after 3 seconds)
func _on_explosion():
	# Play the blast animation once
	animated_sprite.play("blast")  # Trigger the blast animation

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

	# Connect the "animation_finished" signal to remove the bomb after animation finishes
	animated_sprite.animation_finished.connect(self._on_animation_finished)

# This function is called when the "blast" animation finishes
func _on_animation_finished():
	queue_free()  # Remove the bomb from the scene
	print("Bomb removed from scene.")  # Debugging print statement
