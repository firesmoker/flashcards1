class_name NoteButton extends Button

var _note: String = "A"
signal note_pressed
@onready var game_manager: Node2D = %GameManager

func _ready() -> void:
	connect("note_pressed",game_manager.get_user_input)
	connect("button_up",press_button)

func change_note(new_note: String = "F") -> void:
	#print(name + " changing " + _note + " to: " + new_note)
	_note = new_note
	text = _note

func press_button() -> void:
	#print("button pressed, emitting: " + _note)
	emit_signal("note_pressed",_note)


func randomize_note() -> void:
	var new_note: String = game_manager.get_random_note()
	if new_note == _note:
		randomize_note()
	else:
		change_note(new_note)
