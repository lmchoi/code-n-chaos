extends Node

class_name TaskManager

var available_tasks = [
	{
		"title": "Fix CEO's PowerPoint",
		"description": "The CEO needs his presentation fixed. Again.",
		"deadline": 3,  # Days
		"reward_money": 200,
		"reward_rep": -5,  # Soul-crushing
		"chaos_risk": 10,
		"required_skills": {
			"design": 1.0
		},
		"skill_gain": {
			"design": 0.1
		}
	},
	{
		"title": "Freelance: Build a Cat Website",
		"description": "A local cat shelter needs a website. At least it's for a good cause.",
		"deadline": 5,
		"reward_money": 500,
		"reward_rep": 5,
		"chaos_risk": 20,
		"required_skills": {
			"coding": 1.0,
			"design": 1.0
		},
		"skill_gain": {
			"coding": 0.2,
			"design": 0.1
		}
	},
	{
		"title": "Debug Production Server",
		"description": "The production server is down. Again. No pressure.",
		"deadline": 2,
		"reward_money": 300,
		"reward_rep": 3,
		"chaos_risk": 30,
		"required_skills": {
			"coding": 2.0,
			"testing": 1.0
		},
		"skill_gain": {
			"coding": 0.3,
			"testing": 0.2
		}
	}
]

var active_tasks = []
var task_timer = 0.0
var day_length = 60.0  # 60 seconds per in-game day

func _process(delta):
	task_timer += delta
	
	# Update task deadlines
	for task in active_tasks.duplicate():
		task.deadline -= delta / day_length
		if task.deadline <= 0:
			handle_overdue_task(task)
			active_tasks.erase(task)
	
	# Generate new tasks every 2 days
	if task_timer >= day_length * 2:
		task_timer = 0
		generate_new_tasks()

func generate_new_tasks():
	# Add 1-2 new tasks
	var num_new_tasks = randi() % 2 + 1
	for i in range(num_new_tasks):
		var new_task = available_tasks[randi() % available_tasks.size()].duplicate()
		active_tasks.append(new_task)

func handle_overdue_task(task):
	# Apply penalties for overdue tasks
	var player = get_node("/root/Main/Player")
	if player:
		player.add_chaos(20.0)  # Overdue tasks add chaos
		player.add_reputation(-10.0)  # And hurt reputation

func get_available_tasks() -> Array:
	return active_tasks

func start_task(task_index: int) -> Dictionary:
	if task_index >= 0 and task_index < active_tasks.size():
		var task = active_tasks[task_index]
		active_tasks.remove_at(task_index)
		return task
	return {} 