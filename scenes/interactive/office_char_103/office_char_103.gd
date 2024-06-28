extends Node2D
@onready var interaction_area = $InteractionArea
@onready var sprite_2d = $Sprite2D

enum Status {vacant,occupied}
var current_state = Status.vacant

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self,"_on_interact")

func _on_interact():
	if(current_state == Status.vacant):
		current_state= Status.occupied
		interaction_area.action_name="get up"
		InteractionManager.animate_player_interaction("sit_left")
		return
	if(current_state == Status.occupied):
		current_state = Status.vacant
		interaction_area.action_name="Sit"
		InteractionManager.reset_animation()
		
		return
