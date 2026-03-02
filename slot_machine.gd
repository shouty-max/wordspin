extends Node3D
@export var slots:Array[Slot]
@export var slot_sequence_player:AnimationPlayer
@export var handle_pull_player:AnimationPlayer
@export var handle_hover_player:AnimationPlayer

var ready_to_spin = true

func _ready():
	handle_hover_player.play("hover_exit") # easy way to reset texture

func set_letters_and_spin(): # called by PullPlayer animation for timing
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for slot:Slot in slots:
		var result = ""
		for letterInd in 12:
			var char_code = rng.randi_range(65, 90) # ascii A-Z
			result += char(char_code)
		slot.change_hidden(result[0], result[1], result[2], result.substr(3).split(""))
	slot_sequence_player.play("spin_sequence")

func _on_handle_mouse_entered() -> void:
	if ready_to_spin:
		handle_hover_player.play("hover_enter")

func _on_handle_mouse_exited() -> void:
	if ready_to_spin:
		handle_hover_player.play("hover_exit")

func _on_handle_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event.is_action_pressed("game_press"):
		if not handle_pull_player.is_playing() and ready_to_spin:
			ready_to_spin = false
			handle_hover_player.play("hover_exit")
			handle_pull_player.play("pull")

func _on_final_slot_spin_finished(_spinner: Slot) -> void:
	ready_to_spin = true
