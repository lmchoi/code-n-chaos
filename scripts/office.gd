extends Node2D

@onready var task_board = $TaskBoard
@onready var money_label = $UI/StatsContainer/MoneyLabel
@onready var chaos_label = $UI/StatsContainer/ChaosLabel
@onready var tooltip = $UI/Tooltip

var player_node

func _ready():
	print("Office scene ready")
	
	# Get player node
	player_node = get_node("/root/Player")
	if player_node == null:
		push_error("Player autoload not found! Make sure it's registered in Project Settings -> Autoload")
		return
	print("Player node found")
	
	# Connect player signals
	player_node.connect("money_changed", Callable(self, "_on_money_changed"))
	player_node.connect("chaos_changed", Callable(self, "_on_chaos_changed"))
	
	# Update UI
	update_ui()

func update_ui():
	if player_node == null:
		return
	money_label.text = "Money: $%.2f" % player_node.money
	chaos_label.text = "Chaos: %.0f%%" % player_node.chaos

func _on_task_board_pressed():
	print("Task board pressed")  # Debug print
	# Show task board UI
	task_board = preload("res://scenes/task_board.tscn").instantiate()
	$CanvasLayer.add_child(task_board)
	task_board.position = Vector2(100, 100)

func _on_task_board_mouse_entered():
	print("Mouse entered task board")  # Debug print
	show_tooltip("Click to view available tasks")

func _on_task_board_mouse_exited():
	print("Mouse exited task board")  # Debug print
	tooltip.visible = false

func show_tooltip(text: String):
	print("Showing tooltip: ", text)  # Debug print
	tooltip.text = text
	tooltip.visible = true

# Signal handlers
func _on_money_changed(_new_value):
	update_ui()

func _on_chaos_changed(_new_value):
	update_ui() 
