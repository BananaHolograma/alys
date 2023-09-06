class_name DebugDisplay extends Control

@onready var godot_essentials_platformer_movement_component: GodotEssentialsPlatformerMovementComponent = $"../GodotEssentialsPlatformerMovementComponent"
@onready var godot_essentials_finite_state_machine: GodotEssentialsFiniteStateMachine = $"../GodotEssentialsFiniteStateMachine"

@onready var current_state_label: Label = $CurrentState
@onready var actual_velocity_label: Label = %"Actual velocity"


func _ready():
	godot_essentials_finite_state_machine.state_changed.connect(on_state_changed)
	current_state_label.text = godot_essentials_finite_state_machine.current_state.name


func _physics_process(delta):
	actual_velocity_label.text = "Velocity: " + str(Vector2(round(godot_essentials_platformer_movement_component.velocity.x), round(godot_essentials_platformer_movement_component.velocity.y)))


func on_state_changed(_previous_state, new_state):
	current_state_label.text = new_state.name

