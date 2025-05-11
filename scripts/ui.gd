extends CanvasLayer

@onready var money_label = $MainContainer/StatsContainer/MoneyLabel
@onready var users_label = $MainContainer/StatsContainer/UsersLabel
@onready var reputation_label = $MainContainer/StatsContainer/ReputationLabel
@onready var chaos_label = $MainContainer/StatsContainer/ChaosLabel
@onready var current_project_label = $MainContainer/ProjectContainer/CurrentProjectLabel
@onready var progress_bar = $MainContainer/ProjectContainer/ProgressBar
@onready var events_container = $MainContainer/EventsContainer

var main_game: Node

func _ready():
	main_game = get_node("/root/Main")
	update_ui()

func _process(_delta):
	update_ui()

func update_ui():
	# Update stats
	money_label.text = "Money: $%.2f" % main_game.money
	users_label.text = "Users: %d" % main_game.users
	reputation_label.text = "Reputation: %.1f" % main_game.reputation
	chaos_label.text = "Chaos: %.0f%%" % (main_game.chaos_level * 100)
	
	# Update project info
	if main_game.current_project:
		current_project_label.text = "Current Project: %s" % main_game.current_project.name
		progress_bar.value = main_game.current_project.progress * 100
	else:
		current_project_label.text = "Current Project: None"
		progress_bar.value = 0
	
	# Update events
	update_events()

func update_events():
	# Clear existing event labels
	for child in events_container.get_children():
		if child.name != "EventsLabel":
			child.queue_free()
	
	# Add new event labels
	var event_system = main_game.get_node("EventSystem")
	for event in event_system.get_active_events():
		var event_label = Label.new()
		event_label.text = "%s (%.1fs)" % [event.name, event.duration]
		events_container.add_child(event_label) 