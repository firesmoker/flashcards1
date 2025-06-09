class_name NoteButton extends Button

var _note: String = "A"
signal note_pressed
@onready var game_manager: Node2D = %GameManager

func _ready() -> void:
	connect("note_pressed",game_manager.get_user_input)
	connect("button_up",press_button)

func change_note(new_note: String = "F") -> void:
	_note = new_note
	text = _note

func press_button() -> void:
	emit_signal("note_pressed",_note)
