extends CharacterBody2D

const SPEED = 200

@export var player: Node2D  # Assign the player node in the editor
@onready var nav_agent = $NavigationAgent2D as NavigationAgent2D  # Reference to the NavigationAgent2D

func _physics_process(delta: float) -> void:
	# Get the direction towards the next path position
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = dir * SPEED
	move_and_slide()

func make_path() -> void:
	# Update the target position of the navigation agent
	if player:  # Ensure player is assigned
		nav_agent.target_position = player.global_position

func _on_timer_timeout() -> void:
	# Timer triggers path recalculation
	make_path()
