class_name NoteElement extends Control

var note: String
@onready var game_manager: GameManager = %GameManager

func _ready() -> void:
	pass

func change_note(new_note: String) -> void:
	note = new_note

func play_success_effects() -> void:
	pass

func set_element_theme(theme: String = "light") -> void:
	match theme:
		"light":
			pass
		"dark":
			pass

#func position_note(new_note: String) -> void:
	#pass
