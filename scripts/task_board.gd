extends Control

@onready var task_list = $Panel/VBoxContainer/ScrollContainer/TaskList
@onready var back_button = $Panel/VBoxContainer/BackButton

var player_node
var task_manager_node

func _ready():
	print("Task board scene ready")  # Debug print
	
	# Get references to game systems
	player_node = get_node("/root/Player")
	task_manager_node = get_node("/root/TaskManager")
	
	if player_node == null or task_manager_node == null:
		push_error("Failed to get Player or TaskManager autoloads")
		return
	
	print("Got Player and TaskManager nodes")  # Debug print
	
	# Populate task list
	update_task_list()
	
	set_process_input(true)

func update_task_list():
	# Clear existing tasks
	for child in task_list.get_children():
		child.queue_free()
	
	# Add available tasks
	var tasks = task_manager_node.get_available_tasks()
	print("Got tasks: ", tasks.size())  # Debug print
	
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
	var task = task_manager_node.start_task(index)
	if task:
		player_node.start_task(task)
		_on_back_button_pressed()  # Return to office

func _on_back_button_pressed():
	print("Back button pressed")  # Debug print
	hide()
	

func _input(event):
	# Close on ESC
	if event.is_action_pressed("ui_cancel"):
		queue_free()

func _on_gui_input(event):
	# Close when clicking outside (if root is a Panel)
	if event is InputEventMouseButton and event.pressed:
		queue_free()	
