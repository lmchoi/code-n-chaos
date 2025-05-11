extends Node

class_name Player

# Core resources
var money: float = 1000.0  # Starts barely enough for rent
var reputation: float = 0.0  # Improves job offers
var chaos: float = 0.0  # Max 100 → game over (burnout)
var energy: float = 100.0  # Max 100, affects task performance

# Skills
var skills = {
	"coding": 1.0,
	"testing": 1.0,
	"design": 1.0
}

# Game state
var current_task = null
var day_count: int = 0
var is_burned_out: bool = false

signal chaos_changed(new_value)
signal energy_changed(new_value)
signal money_changed(new_value)
signal reputation_changed(new_value)
signal skill_improved(skill_name, new_value)
signal burnout_triggered

func _process(delta):
	# Natural chaos reduction over time
	chaos = max(0.0, chaos - delta * 0.1)
	
	# Check for burnout
	if chaos >= 100.0 and not is_burned_out:
		trigger_burnout()

func add_chaos(amount: float):
	chaos = min(100.0, chaos + amount)
	emit_signal("chaos_changed", chaos)

func add_energy(amount: float):
	energy = min(100.0, energy + amount)
	emit_signal("energy_changed", energy)

func use_energy(amount: float):
	energy = max(0.0, energy - amount)
	emit_signal("energy_changed", energy)

func add_money(amount: float):
	money += amount
	emit_signal("money_changed", money)

func add_reputation(amount: float):
	reputation += amount
	emit_signal("reputation_changed", reputation)

func improve_skill(skill_name: String, amount: float):
	if skills.has(skill_name):
		skills[skill_name] += amount
		emit_signal("skill_improved", skill_name, skills[skill_name])

func start_task(task_data: Dictionary):
	current_task = task_data
	use_energy(20.0)  # Starting a task costs energy

func complete_task():
	if current_task:
		# Calculate rewards based on performance
		var performance = calculate_task_performance()
		
		# Apply rewards
		add_money(current_task.reward_money * performance)
		add_reputation(current_task.reward_rep * performance)
		add_chaos(current_task.chaos_risk * (1.0 - performance))
		
		# Improve relevant skills
		if current_task.has("skill_gain"):
			for skill in current_task.skill_gain:
				improve_skill(skill, current_task.skill_gain[skill] * performance)
		
		current_task = null

func calculate_task_performance() -> float:
	if not current_task:
		return 0.0
	
	var base_performance = 1.0
	
	# Energy affects performance
	base_performance *= energy / 100.0
	
	# Chaos reduces performance
	base_performance *= 1.0 - (chaos / 200.0)  # At 100 chaos, performance is halved
	
	# Skills affect performance if task requires them
	if current_task.has("required_skills"):
		for skill in current_task.required_skills:
			if skills.has(skill):
				base_performance *= min(skills[skill] / current_task.required_skills[skill], 2.0)
	
	return clamp(base_performance, 0.0, 1.0)

func trigger_burnout():
	is_burned_out = true
	emit_signal("burnout_triggered")
	# TODO: Implement burnout consequences 