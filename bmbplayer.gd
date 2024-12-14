#extends CharacterBody2D
#
## Movement speed
#const SPEED = 200
#
#func _ready():
	## Initialize anything here if necessary
	#pass
#
#func _physics_process(delta: float) -> void:
	## Horizontal movement (X axis)
	#if Input.is_action_pressed("ui_right"):
		#velocity.x = SPEED  # Move right
	#elif Input.is_action_pressed("ui_left"):
		#velocity.x = -SPEED  # Move left
	#else:
		#velocity.x = 0  # Stop horizontal movement if no input
#
	## Vertical movement (Y axis)
	#if Input.is_action_pressed("ui_down"):
		#velocity.y = SPEED  # Move down
	#elif Input.is_action_pressed("ui_up"):
		#velocity.y = -SPEED  # Move up
	#else:
		#velocity.y = 0  # Stop vertical movement if no input
#
	## Move the character (use move_and_slide to handle physics)
	#move_and_slide()  # No need to pass velocity, it uses the class's `velocity` property











extends CharacterBody2D

var bomb_scene: PackedScene  # Declare without @export

@export var walk_sound: AudioStream  # Single walk sound (OGG file)
@export var bomb_throw_sound: AudioStream  # Sound when bomb is thrown
@export var death_sound: AudioStream  # Sound when player dies

const SPEED = 150

# Reference to the AnimatedSprite2D node
var animated_sprite: AnimatedSprite2D
var walk_sound_player: AudioStreamPlayer2D  # Reference to the AudioStreamPlayer2D node for walking sound
var bomb_throw_sound_player: AudioStreamPlayer2D  # Reference to the AudioStreamPlayer2D node for bomb throw sound
var death_sound_player: AudioStreamPlayer2D  # Reference to the AudioStreamPlayer2D node for death sound

# Track the current animation to prevent unnecessary restarts
var current_animation: String = ""

# Placeholder for death condition
var is_dead: bool = false  # Set this to true when the player dies (this is just an example)

func _ready():
	# Load the bomb scene programmatically
	bomb_scene = load("res://scenes/bomb.tscn")  # Path to your bomb scene
	if bomb_scene == null:
		print("ERROR: Could not load bomb scene!")
	else:
		print("Bomb scene loaded successfully!")

	# Safely get the AnimatedSprite2D and AudioStreamPlayer2D nodes
	animated_sprite = $AnimatedSprite2D
	if animated_sprite == null:
		print("Error: AnimatedSprite2D node not found!")

	# Get the AudioStreamPlayer2D nodes
	walk_sound_player = $AudioStreamPlayer2D
	if walk_sound_player == null:
		print("Error: AudioStreamPlayer2D node for walk sound not found!")

	bomb_throw_sound_player = $BombThrowSoundPlayer
	if bomb_throw_sound_player == null:
		print("Error: AudioStreamPlayer2D node for bomb throw sound not found!")

	death_sound_player = $DeathSoundPlayer
	if death_sound_player == null:
		print("Error: AudioStreamPlayer2D node for death sound not found!")

	# Check if the walk sound is assigned
	if walk_sound == null:
		print("Warning: Walk sound not assigned!")
	if bomb_throw_sound == null:
		print("Warning: Bomb throw sound not assigned!")
	if death_sound == null:
		print("Warning: Death sound not assigned!")

func _physics_process(delta: float) -> void:
	# Prevent movement if the player is dead
	if is_dead:
		# Ensure that we stop any movement or further input processing when dead
		# Also, ensure no further actions are executed when the player is dead.
		return

	# Track movement input
	var input_direction = Vector2.ZERO

	# Horizontal movement (X axis)
	if Input.is_action_pressed("ui_right"):
		input_direction.x = 1  # Move right
		animated_sprite.flip_h = true  # Ensure sprite is not flipped horizontally
	elif Input.is_action_pressed("ui_left"):
		input_direction.x = -1  # Move left
		animated_sprite.flip_h = false # Flip sprite horizontally for left direction

	# Vertical movement (Y axis)
	if Input.is_action_pressed("ui_down"):
		input_direction.y = 1  # Move down
	elif Input.is_action_pressed("ui_up"):
		input_direction.y = -1  # Move up

	# Set velocity based on input direction
	velocity = input_direction * SPEED

	# Adjust the pitch of the walk sound based on the player's speed
	if input_direction != Vector2.ZERO:
		# Calculate a pitch factor based on the player's movement speed
		var speed_factor = velocity.length() / SPEED
		var speed_multiplier = 1.5  # Double the speed for the sound (set to 3.0 for triple speed)

		# Set the pitch scale to make the sound faster (e.g., double or triple the speed)
		walk_sound_player.pitch_scale = speed_factor * speed_multiplier  # Make sound faster

		# Play walking sound if it's not already playing
		if not walk_sound_player.playing:
			play_walk_sound()

		# Set the walking animation
		if input_direction.x != 0:
			set_animation("side_walk")
		elif input_direction.y > 0:
			set_animation("front_walk")
		elif input_direction.y < 0:
			set_animation("back_walk")
	else:
		# Stop walking sound when idle
		if walk_sound_player.playing:
			walk_sound_player.stop()

		# Set the idle animation
		if current_animation == "side_walk":
			set_animation("side_idle")
		elif current_animation == "front_walk":
			set_animation("front_idle")
		elif current_animation == "back_walk":
			set_animation("back_idle")

	# Move the character (use move_and_slide to handle physics)
	move_and_slide()

	# Throw bomb when space is pressed
	if Input.is_action_just_pressed("ui_accept"):  # Space bar by default
		print("Throwing bomb")  # Debugging print statement
		if bomb_scene:  # Check if bomb_scene is loaded successfully
			var bomb_instance = bomb_scene.instantiate()
			print("Bomb instantiated: ", bomb_instance)  # Debugging print statement
			bomb_instance.position = position + Vector2(0, -20)  # Optional offset to make bomb appear above player
			get_parent().add_child(bomb_instance)
			print("Bomb added to the scene")  # Debugging print statement

			# Play bomb throw sound
			play_bomb_throw_sound()
		else:
			print("Bomb scene not loaded!")  # Error if bomb_scene is not loaded

	# Handle player death (this is a placeholder example)
	if is_dead:  # Check if the player is "dead"
		hide_sprite_and_play_death_sound()

# Helper function to manage animations efficiently
func set_animation(animation_name: String) -> void:
	if current_animation != animation_name:  # Only play if it's a new animation
		animated_sprite.play(animation_name)
		current_animation = animation_name

# Function to play walking sound
func play_walk_sound() -> void:
	if walk_sound != null and walk_sound_player != null:
		walk_sound_player.stream = walk_sound  # Set the walk sound to the AudioStreamPlayer2D
		walk_sound_player.play()  # Play the sound

# Function to play bomb throw sound
func play_bomb_throw_sound() -> void:
	if bomb_throw_sound != null and bomb_throw_sound_player != null:
		bomb_throw_sound_player.stream = bomb_throw_sound  # Set the bomb throw sound to the AudioStreamPlayer2D
		bomb_throw_sound_player.play()  # Play the sound

# Function to play death sound, hide the sprite, and pause the game
func hide_sprite_and_play_death_sound() -> void:
	# Hide the sprite immediately when the player dies
	animated_sprite.visible = false

	# Play death sound if it's not already playing
	if not death_sound_player.playing:
		death_sound_player.stream = death_sound
		death_sound_player.play()

		# Pause the game
		get_tree().paused = true

		# Use a timer to wait for the death sound to finish before removing the player
		var death_timer = Timer.new()
		add_child(death_timer)
		death_timer.wait_time = death_sound.length  # Wait for the duration of the death sound
		death_timer.one_shot = true
		death_timer.connect("timeout", Callable(self, "_on_death_sound_finished"))
		death_timer.start()

# Function called when the death sound finishes playing
func _on_death_sound_finished():
	# Unpause the game
	get_tree().paused = false

	# Remove the player from the scene
	queue_free()
