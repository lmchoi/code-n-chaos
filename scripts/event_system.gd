extends Node

class_name EventSystem

var events = [
	{
		"name": "Server Crash",
		"description": "The production server just crashed!",
		"impact": {
			"chaos": 0.3,
			"reputation": -0.1
		},
		"duration": 2.0
	},
	{
		"name": "Coffee Machine Broken",
		"description": "The coffee machine is out of order! Productivity will suffer.",
		"impact": {
			"chaos": 0.1,
			"progress": -0.2
		},
		"duration": 1.0
	},
	{
		"name": "Last Minute Requirements",
		"description": "The client just changed their requirements!",
		"impact": {
			"chaos": 0.2,
			"deadline": -0.5
		},
		"duration": 1.5
	}
]

var active_events = []
var event_timer = 0.0
var event_interval = 30.0  # Time between possible events in seconds

func _process(delta):
	event_timer += delta
	
	# Update active events
	for event in active_events.duplicate():
		event.duration -= delta
		if event.duration <= 0:
			active_events.erase(event)
	
	# Check for new events
	if event_timer >= event_interval:
		event_timer = 0
		if randf() < 0.3:  # 30% chance of event
			trigger_random_event()

func trigger_random_event():
	var event = events[randi() % events.size()].duplicate()
	active_events.append(event)
	print("Event triggered: ", event.name)
	# TODO: Notify UI and game state about the event

func get_active_events() -> Array:
	return active_events

func get_event_impact() -> Dictionary:
	var total_impact = {
		"chaos": 0.0,
		"reputation": 0.0,
		"progress": 0.0,
		"deadline": 0.0
	}
	
	for event in active_events:
		for impact_type in event.impact:
			total_impact[impact_type] += event.impact[impact_type]
	
	return total_impact 
