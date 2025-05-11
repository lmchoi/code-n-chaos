extends Control

@onready var player = $Player
@onready var task_manager = $TaskManager

func _ready():
	# Initialize game systems
	player = get_node("/root/Player")
	task_manager = get_node("/root/TaskManager")
	
	# Connect start button
	$TitleContainer/StartButton.connect("pressed", Callable(self, "_on_start_button_pressed"))

func _on_start_button_pressed():
	print("Starting game...")
	# Change to the office scene
	get_tree().change_scene_to_file("res://scenes/office.tscn") 
