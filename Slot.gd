extends MeshInstance3D
class_name Slot

signal spin_finished(spinner)

@export var facing_top1:Label3D
@export var facing_mid1:Label3D
@export var facing_bot1:Label3D
@export var facing_top2:Label3D
@export var facing_mid2:Label3D
@export var facing_bot2:Label3D
@export var others:Array[Label3D]
@export var spin_player:AnimationPlayer
@export var spin_holder:Node3D

var facing1 = true

func _ready():
	var all = others.duplicate()
	all.append_array([facing_top1, facing_mid1, facing_bot1, facing_top2, facing_mid2, facing_bot2])
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for label in all:
		label.text = char(rng.randi_range(65, 90)) # ascii A-Z
		label.modulate = Color.from_hsv(rng.randf_range(0, 1.0), 0.5, 1.0)

func change_hidden(next_roll:String, next_top:String, next_bot:String, the_others:Array[String]):
	var top
	var mid
	var bot
	if facing1:
		mid = facing_mid2
		top = facing_top2
		bot = facing_bot2
	else:
		mid = facing_mid1
		top = facing_top1
		bot = facing_bot1
	top.text = next_top
	mid.text = next_roll
	bot.text = next_bot
	for otherInd in self.others.size():
		self.others[otherInd].text = the_others[otherInd]
	var color_changing:Array[Label3D] = others.duplicate()
	color_changing.append_array([top, mid, bot])
	var rng = RandomNumberGenerator.new()
	for label in color_changing:
		label.modulate = Color.from_hsv(rng.randf_range(0, 1.0), 0.5, 1.0)

func roll(playback_speed = 1.0):
	if facing1:
		spin_holder.rotation.y = 0
	else:
		spin_holder.rotation.y = PI
	spin_player.play("spin", -1, playback_speed)
	facing1 = not facing1

func _on_spin_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "spin":
		emit_signal("spin_finished", self)
