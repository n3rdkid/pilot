extends Node2D
@onready var interaction_area = $InteractionArea
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer

enum Status {open,closed}
var current_state = Status.closed

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self,"_on_interact")

func _on_interact():
	if(current_state == Status.closed):
		current_state= Status.open
		animated_sprite_2d.play("open_door")
		animation_player.play("open_door")
		return
	if(current_state == Status.open):
		current_state = Status.closed
		animated_sprite_2d.play_backwards("open_door")
		animation_player.play("RESET")
		return

