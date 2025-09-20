extends Control

@onready var music_volume: Label = $HBoxContainer/ValueContainer/MusicVolume
@onready var sfx_volume: Label = $HBoxContainer/ValueContainer/SfxVolume

@onready var music_down: Button = $HBoxContainer/DownButtonsContainer/MarginContainer/MusicDown
@onready var sfxdown: Button = $HBoxContainer/DownButtonsContainer/MarginContainer2/SFXDown

@onready var music_up: Button = $HBoxContainer/UpButtonsContainer/MarginContainer/MusicUp
@onready var sfxup: Button = $HBoxContainer/UpButtonsContainer/MarginContainer2/SFXUp

var music_index = AudioServer.get_bus_index("music")
var sfx_index = AudioServer.get_bus_index("sfx")



signal returned_to_pause_menu()

func _ready() -> void:
	update_music_label(StoredValues.music_volume_value)
	update_sfx_label(StoredValues.sfx_volume_value)
	set_music_volume_db(StoredValues.music_volume_value)
	set_sfx_volume_db(StoredValues.sfx_volume_value)
	

func update_music_label(value: int) -> void:
	music_volume.text = str(value)

func update_sfx_label(value: int) -> void:
	sfx_volume.text = str(value)

func set_music_volume_db(value: int) -> void:
	StoredValues.music_volume_value = clamp(value, 0, 10)

	var db_value = lerp(-80, 0, StoredValues.music_volume_value / 10.0)
	AudioServer.set_bus_volume_db(music_index, db_value)
	update_music_label(StoredValues.music_volume_value)

func set_sfx_volume_db(value: int) -> void:
	StoredValues.sfx_volume_value = clamp(value, 0, 10)
	var db_value = lerp(-80, 0, StoredValues.sfx_volume_value / 10.0)
	AudioServer.set_bus_volume_db(sfx_index, db_value)
	update_sfx_label(StoredValues.sfx_volume_value)


func _on_music_down_pressed() -> void:
	set_music_volume_db(StoredValues.music_volume_value - 1)

func _on_music_up_pressed() -> void:
	set_music_volume_db(StoredValues.music_volume_value + 1)


func _on_sfx_down_pressed() -> void:
	set_sfx_volume_db(StoredValues.sfx_volume_value - 1)


func _on_sfx_up_pressed() -> void:
	set_sfx_volume_db(StoredValues.sfx_volume_value + 1)


func _on_crt_button_toggled(toggled_on: bool) -> void:
	GameManager.toggle_crt(toggled_on)


func _on_return_to_pause_pressed() -> void:
	returned_to_pause_menu.emit()


func esc() -> void:
	if Input.is_action_just_pressed("escape") and visible:
		returned_to_pause_menu.emit()

func _process(_delta):
	esc()
