class_name PossessButton
extends Button

@onready var timer: Timer = $Timer
@onready var variable_pitch_audio_stream_player: AudioStreamPlayer = $VariablePitchAudioStreamPlayer
@onready var cooldown: TextureProgressBar = $Cooldown1

var skill: PossessSkill

func _ready() -> void:
	set_process(false)

	cooldown.max_value = timer.wait_time

func _process(_delta):
	cooldown.value = timer.time_left

func _on_timer_timeout() -> void:
	disabled = false
	set_process(false) 
	cooldown.value = 0.0

func _on_pressed() -> void:
	skill.cast_spell(owner)
	timer.start()
	disabled = true
	set_process(true)
	variable_pitch_audio_stream_player.play()
