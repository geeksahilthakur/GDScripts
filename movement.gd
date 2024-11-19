extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -400.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D  # Correct node reference

func _ready():
	if animated_sprite_2d == null:
		print("Error: AnimatedSprite2D node not found!")
	else:
		print("AnimatedSprite2D node found successfully!")

func _physics_process(delta: float) -> void:
	# Add gravity if the player is not on the floor
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump (when pressing the jump button and character is on the floor)
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animated_sprite_2d.play("jump")  # Play jump animation when jumping

	# Get the horizontal movement direction
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction:
		# Move left or right
		velocity.x = direction * SPEED
		if not animated_sprite_2d.is_playing() or animated_sprite_2d.animation != "run":
			animated_sprite_2d.play("run")  # Play run animation if moving
		
		# Flip the sprite based on direction (left or right)
		if direction < 0:
			animated_sprite_2d.flip_h = true  # Flip to the left
		elif direction > 0:
			animated_sprite_2d.flip_h = false  # Flip to the right
	else:
		# Stop horizontal movement
		velocity.x = move_toward(velocity.x, 0, SPEED)

		# If no movement, make sure the character is not in a running animation
		if animated_sprite_2d.animation == "run":
			animated_sprite_2d.stop()  # Optionally, stop the run animation when idle

	# If the character is on the ground and not jumping, stop playing the "Jump" animation
	if is_on_floor() and velocity.y == 0 and animated_sprite_2d.animation == "jump":
		animated_sprite_2d.stop()  # Optionally, stop the jump animation when landing

	move_and_slide()
