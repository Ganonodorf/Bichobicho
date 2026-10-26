extends AnimationTree

@export_category("Animation Tree Parameter Paths")
@export var right_wing_shot_path: String = "parameters/RightWingShot/request"
@export var left_wing_shot_path: String = "parameters/LeftWingShot/request"
@export var shell_add_path: String = "parameters/AddIddleWings/add_amount"
@export var move_shot_path: String = "parameters/MoveShot/request" # <--- Path for your ground movement OneShot

@export_category("Shell Settings")
@export var shell_close_delay: float = 1.5
@export var shell_lerp_speed: float = 8.0

@onready var shell_timer: Timer = _get_or_create_shell_timer()

var current_shell_amount: float = 0.0
var target_shell_amount: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	active = true
	_connect_to_all_patas()

func _process(delta: float) -> void:
	if current_shell_amount != target_shell_amount:
		current_shell_amount = move_toward(current_shell_amount, target_shell_amount, delta * shell_lerp_speed)
		set(shell_add_path, current_shell_amount)

# --- Auto-Discovery & Signal Connection ---
func _connect_to_all_patas() -> void:
	var parent_bug = get_parent()
	if not parent_bug:
		return
		
	# Scan all sibling nodes under the bug on startup
	for child in parent_bug.get_children():
		# Directly check if the node is of class type Pata
		if child is Pata:
			print("Found Pata: ", child.name) # Helpful debug print to check in Output!
			
			# Connect wing signals
			if not child.animated_wing_pata_fired.is_connected(trigger_wing_flap):
				child.animated_wing_pata_fired.connect(trigger_wing_flap)
			
			# Connect ground movement signals
			if not child.animated_ground_pata_fired.is_connected(trigger_body_movement):
				child.animated_ground_pata_fired.connect(trigger_body_movement)



# --- Public API Triggered by Pata Signals ---

func trigger_wing_flap(is_right_wing: bool) -> void:
	_open_shells()
	_restart_shell_timer()
	
	if is_right_wing:
		set(right_wing_shot_path, AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	else:
		set(left_wing_shot_path, AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func trigger_body_movement() -> void:
	set(move_shot_path, AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

# --- Internal Shell & Timer Logic ---

func _open_shells() -> void:
	target_shell_amount = 1.0
	_restart_shell_timer()

func _close_shells() -> void:
	target_shell_amount = 0.0

func _get_or_create_shell_timer() -> Timer:
	var timer = get_node_or_null("ShellCloseTimer")
	if not timer:
		timer = Timer.new()
		timer.name = "ShellCloseTimer"
		timer.one_shot = true
		timer.timeout.connect(_on_shell_timer_timeout)
		add_child(timer)
	
	timer.wait_time = shell_close_delay
	return timer

func _restart_shell_timer() -> void:
	shell_timer.start()

func _on_shell_timer_timeout() -> void:
	_close_shells()
