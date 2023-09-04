@tool
extends EditorPlugin

const HELPERS_AUTOLOAD = "Helpers"
var update_dialog_scene: UpdateGodot2DEssentialsButton


func _enter_tree():
	add_autoload_singleton(HELPERS_AUTOLOAD, "res://addons/2d_essentials/autoload/helpers.tscn")
	add_custom_type("HealthComponent", "Node2D", preload("res://addons/2d_essentials/survivability/health_component.gd"), preload("res://addons/2d_essentials/icons/suit_hearts.svg"))
	add_custom_type("ShakeCameraComponent2D", "Node2D", preload("res://addons/2d_essentials/camera/shake_camera_component.gd"), preload("res://addons/2d_essentials/icons/video.png"))
	add_custom_type("RotatorComponent", "Node2D", preload("res://addons/2d_essentials/movement/rotator_component.gd"), preload("res://addons/2d_essentials/icons/arrow_clockwise.svg"))
	add_custom_type("ProjectileComponent", "Node2D", preload("res://addons/2d_essentials/movement/rotator_component.gd"), preload("res://addons/2d_essentials/icons/bow.png"))
	add_custom_type("GodotEssentialsFiniteStateMachine", "Node", preload("res://addons/2d_essentials/patterns/finite_state_machine/finite_state_machine.gd"), preload("res://addons/2d_essentials/icons/share2.png"))
	add_custom_type("GodotEssentialsState", "Node", preload("res://addons/2d_essentials/patterns/finite_state_machine/state.gd"), preload("res://addons/2d_essentials/icons/target.png"))
	add_custom_type("GodotEssentialsPlatformerMovementComponent", "Node2D", preload("res://addons/2d_essentials/movement/motion/platformer_movement_component.gd"), preload("res://addons/2d_essentials/icons/target.png"))
	add_custom_type("GodotEssentialsTopDownMovementComponent", "Node2D", preload("res://addons/2d_essentials/movement/motion/top_down_movement_component.gd"), preload("res://addons/2d_essentials/icons/arrow_diagonal.png"))
	add_custom_type("GodotEssentialsGridMovementComponent", "Node2D", preload("res://addons/2d_essentials/movement/motion/grid_movement_component.gd"), preload("res://addons/2d_essentials/icons/menu_grid.png"))
	
	_setup_update_notificator()
	

func _exit_tree():
	remove_autoload_singleton(HELPERS_AUTOLOAD)
	remove_custom_type("HealthComponent")
	remove_custom_type("ShakeCameraComponent2D")
	remove_custom_type("RotatorComponent")
	remove_custom_type("ProjectileComponent")
	remove_custom_type("GodotEssentialsFiniteStateMachine")
	remove_custom_type("GodotEssentialsState")
	remove_custom_type("GodotEssentialsPlatformerMovementComponent")
	remove_custom_type("GodotEssentialsTopDownMovementComponent")
	remove_custom_type("GodotEssentialsGridMovementComponent")
	
	_remove_update_notificator()


func _setup_update_notificator():
	update_dialog_scene = load("res://addons/2d_essentials/update/update_plugin_button.tscn").instantiate() as UpdateGodot2DEssentialsButton
	Engine.get_main_loop().root.call_deferred("add_child", update_dialog_scene)
	
	update_dialog_scene.editor_plugin = self
	

func _remove_update_notificator():
	if update_dialog_scene:
		Engine.get_main_loop().root.call_deferred("remove_child", update_dialog_scene)
