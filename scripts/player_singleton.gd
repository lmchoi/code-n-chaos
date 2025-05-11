extends Node

# Player stats
var money: float = 1000.0
var energy: float = 100.0
var chaos: float = 0.0
var current_task: Dictionary = {}

signal money_changed(new_value)
signal energy_changed(new_value)
signal chaos_changed(new_value)

func add_money(amount: float):
	money += amount
	emit_signal("money_changed", money)

func add_energy(amount: float):
	energy = clamp(energy + amount, 0.0, 100.0)
	emit_signal("energy_changed", energy)

func add_chaos(amount: float):
	chaos = clamp(chaos + amount, 0.0, 100.0)
	emit_signal("chaos_changed", chaos)

func start_task(task: Dictionary):
	current_task = task
	energy -= 20.0  # Starting a task costs energy

func complete_task():
	if current_task:
		add_money(current_task.reward_money)
		add_chaos(current_task.chaos_risk)
		current_task = {} 