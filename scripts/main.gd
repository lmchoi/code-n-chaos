extends Node

# Game state variables
var money: float = 1000.0
var users: int = 0
var reputation: float = 0.0
var chaos_level: float = 0.0

# Player stats
var skills = {
	"coding": 1.0,
	"design": 1.0,
	"testing": 1.0,
	"management": 1.0
}

# Current project
var current_project = null

func _ready():
	initialize_game()

func initialize_game():
	# Initialize game state
	print("Game initialized!")
	# TODO: Load saved game if exists
	# TODO: Initialize UI
	# TODO: Set up event system

func _process(delta):
	# Update game state
	update_game_state(delta)

func update_game_state(delta):
	if current_project:
		# Update project progress
		pass
	# Update chaos level
	chaos_level = max(0.0, chaos_level - delta * 0.1)  # Chaos naturally decreases over time

func start_project(project_data):
	current_project = project_data
	print("Started new project: ", project_data.name)

func complete_project():
	if current_project:
		# Calculate rewards
		money += current_project.reward
		users += current_project.user_impact
		reputation += current_project.reputation_impact
		current_project = null 