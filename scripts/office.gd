extends Node2D

@onready var desk = $Desk
@onready var coffee_machine = $CoffeeMachine
@onready var task_board = $TaskBoard
@onready var money_label = $UI/StatsContainer/MoneyLabel
@onready var energy_label = $UI/StatsContainer/EnergyLabel
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
	
	# Connect signals
	desk.connect("input_event", Callable(self, "_on_desk_input_event"))
	coffee_machine.connect("input_event", Callable(self, "_on_coffee_machine_input_event"))
	task_board.connect("input_event", Callable(self, "_on_task_board_input_event"))
	
	# Connect player signals
	player_node.connect("money_changed", Callable(self, "_on_money_changed"))
	player_node.connect("energy_changed", Callable(self, "_on_energy_changed"))
	player_node.connect("chaos_changed", Callable(self, "_on_chaos_changed"))
	
	# Update UI
	update_ui()

func _process(_delta):
	# Update tooltip visibility
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		tooltip.visible = false

func update_ui():
	if player_node == null:
		return
	money_label.text = "Money: $%.2f" % player_node.money
	energy_label.text = "Energy: %.0f%%" % player_node.energy
	chaos_label.text = "Chaos: %.0f%%" % player_node.chaos

func _on_desk_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if player_node == null:
			return
		if player_node.current_task:
			# Show coding minigame
			get_tree().change_scene_to_file("res://scenes/dev_minigame.tscn")
		else:
			show_tooltip("No active task. Visit the task board first!")

func _on_coffee_machine_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if player_node == null:
			return
		if player_node.money >= 2.0:
			player_node.add_money(-2.0)  # Coffee costs $2
			player_node.add_energy(30.0)  # Restores 30% energy
			show_tooltip("Coffee consumed! +30% Energy")
		else:
			show_tooltip("Not enough money for coffee!")

func _on_task_board_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		# Show task board UI
		get_tree().change_scene_to_file("res://scenes/task_board.tscn")

func show_tooltip(text: String):
	tooltip.text = text
	tooltip.visible = true

# Signal handlers
func _on_money_changed(_new_value):
	update_ui()

func _on_energy_changed(_new_value):
	update_ui()

func _on_chaos_changed(_new_value):
	update_ui() 