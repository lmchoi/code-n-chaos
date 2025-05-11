extends Control

@onready var task_title = $VBoxContainer/TaskTitle
@onready var code_editor = $VBoxContainer/CodeEditor
@onready var submit_button = $VBoxContainer/HBoxContainer/SubmitButton
@onready var cancel_button = $VBoxContainer/HBoxContainer/CancelButton

var player: Player
var current_task: Dictionary
var code_templates = {
	"Fix CEO's PowerPoint": "function fix_presentation() {\n    // Fix the presentation\n    return true;\n}",
	"Freelance: Build a Cat Website": "function create_cat_website() {\n    // Create a website for cats\n    return true;\n}",
	"Debug Production Server": "function debug_server() {\n    // Debug the server issues\n    return true;\n}"
}

func _ready():
	# Get player reference
	player = get_node("/root/Main/Player")
	current_task = player.current_task
	
	# Connect buttons
	submit_button.connect("pressed", Callable(self, "_on_submit_pressed"))
	cancel_button.connect("pressed", Callable(self, "_on_cancel_pressed"))
	
	# Set up the minigame
	setup_minigame()

func setup_minigame():
	if current_task:
		task_title.text = current_task.title
		if code_templates.has(current_task.title):
			code_editor.text = code_templates[current_task.title]
	else:
		_on_cancel_pressed()  # No task, return to office

func _on_submit_pressed():
	if current_task:
		# Simple completion check
		var code = code_editor.text
		if code.length() > 20:  # Basic check for effort
			player.complete_task()
			show_message("Task completed successfully!")
		else:
			show_message("Code seems incomplete. Try harder!")
		_on_cancel_pressed()

func _on_cancel_pressed():
	get_tree().change_scene_to_file("res://scenes/office.tscn")

func show_message(text: String):
	# TODO: Implement proper message display
	print(text) 