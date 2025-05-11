extends Control

@onready var task_list = $Panel/VBoxContainer/ScrollContainer/TaskList
@onready var back_button = $Panel/VBoxContainer/BackButton

var player: Player
var task_manager: TaskManager

func _ready():
	# Get references to game systems
	player = get_node("/root/Main/Player")
	task_manager = get_node("/root/Main/TaskManager")
	
	# Connect back button
	back_button.connect("pressed", Callable(self, "_on_back_button_pressed"))
	
	# Populate task list
	update_task_list()

func update_task_list():
	# Clear existing tasks
	for child in task_list.get_children():
		child.queue_free()
	
	# Add available tasks
	var tasks = task_manager.get_available_tasks()
	for i in range(tasks.size()):
		var task = tasks[i]
		var task_button = create_task_button(task, i)
		task_list.add_child(task_button)

func create_task_button(task: Dictionary, index: int) -> Button:
	var button = Button.new()
	button.text = format_task_info(task)
	button.connect("pressed", Callable(self, "_on_task_selected").bind(index))
	return button

func format_task_info(task: Dictionary) -> String:
	var info = "%s\n" % task.title
	info += "Deadline: %d days\n" % task.deadline
	info += "Reward: $%d (+%d rep)\n" % [task.reward_money, task.reward_rep]
	info += "Chaos Risk: %d%%" % task.chaos_risk
	return info

func _on_task_selected(index: int):
	var task = task_manager.start_task(index)
	if task:
		player.start_task(task)
		_on_back_button_pressed()  # Return to office

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/office.tscn") 