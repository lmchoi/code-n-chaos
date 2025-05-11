extends Node

var available_tasks = [
	{
		"title": "Fix CEO's PowerPoint",
		"deadline": 3,
		"reward_money": 200,
		"reward_rep": -5,
		"chaos_risk": 10
	},
	{
		"title": "Freelance: Build a Cat Website",
		"deadline": 5,
		"reward_money": 500,
		"reward_rep": 5,
		"chaos_risk": 20
	},
	{
		"title": "Debug Production Server",
		"deadline": 2,
		"reward_money": 300,
		"reward_rep": 10,
		"chaos_risk": 30
	}
]

func get_available_tasks() -> Array:
	return available_tasks

func start_task(index: int) -> Dictionary:
	if index >= 0 and index < available_tasks.size():
		return available_tasks[index]
	return {} 