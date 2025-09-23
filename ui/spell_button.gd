class_name SpellButton
extends TextureButton
@onready var cooldown: TextureProgressBar = $Cooldown1
@onready var key: Label = $Key
@onready var time: Label = $Time
@onready var timer: Timer = $Timer
@onready var variable_pitch_audio_stream_player: AudioStreamPlayer = $VariablePitchAudioStreamPlayer
var skill = null

var change_key: String= "":
	set(value):
		change_key = value
		key.text = value

		#shortcut = Shortcut.new()
		#var input_key = InputEventKey.new()
		#input_key.key_label = value.unicode_at(0)
		#shortcut.events = [input_key]
		

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(change_key) and !disabled:
		_on_pressed()


func _ready() -> void:
	change_key = "1"
	cooldown.max_value = timer.wait_time
	set_process(false)


func _process(_delta: float) -> void:
	time.text = "%3.1f" % timer.time_left
	cooldown.value = timer.time_left


func _on_timer_timeout() -> void:
	disabled = false
	cooldown.value = 0.0

	set_process(false) 

func _on_pressed() -> void:
	if skill != null:
		skill.cast_spell(owner)
		timer.start()
		disabled = true
		set_process(true)
		variable_pitch_audio_stream_player.play()
