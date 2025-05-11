extends Node

class_name Project

var name: String
var description: String
var deadline: float
var reward: float
var user_impact: int
var reputation_impact: float
var required_skills: Dictionary
var progress: float = 0.0
var time_spent: float = 0.0

func _init(project_data: Dictionary):
	name = project_data.get("name", "Unnamed Project")
	description = project_data.get("description", "")
	deadline = project_data.get("deadline", 0.0)
	reward = project_data.get("reward", 0.0)
	user_impact = project_data.get("user_impact", 0)
	reputation_impact = project_data.get("reputation_impact", 0.0)
	required_skills = project_data.get("required_skills", {})

func update_progress(delta: float, player_skills: Dictionary, chaos_level: float) -> float:
	# Calculate progress based on skills, time spent, and chaos level
	var skill_multiplier = calculate_skill_multiplier(player_skills)
	var chaos_penalty = 1.0 - (chaos_level * 0.5)  # Chaos reduces progress by up to 50%
	
	time_spent += delta
	progress += delta * skill_multiplier * chaos_penalty
	
	return progress

func calculate_skill_multiplier(player_skills: Dictionary) -> float:
	var multiplier = 1.0
	for skill in required_skills:
		if player_skills.has(skill):
			multiplier *= min(player_skills[skill] / required_skills[skill], 2.0)
	return multiplier

func is_completed() -> bool:
	return progress >= 1.0

func is_overdue() -> bool:
	return time_spent > deadline 