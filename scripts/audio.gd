class_name Audio extends AudioStreamPlayer2D

var sound_library: Dictionary = {}
var click_sound: AudioStream
var wrong_sound: AudioStream

func _ready() -> void:
	register_sound("click", "res://click2.wav")
	register_sound("wrong", "res://wrong1.wav")

func get_sound(sound_name: String) -> AudioStream:
	if not sound_library[sound_name] == null:
		return sound_library[sound_name]
	else:
		print("null sound!")
		return null
	
func register_sound(sound_name: String, path: String) -> void:
	sound_library[sound_name] = load(path)
