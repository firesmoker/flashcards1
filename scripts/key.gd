extends Button
@onready var game_manager: GameManager = %GameManager
var current_game: GameType
var note_element: NoteElement = NoteElement.new()
signal key_pressed

func _ready() -> void:
	note_element.note = text + "4"
	current_game = game_manager.get_current_game_instance()
	connect("key_pressed",current_game.get_played_key)
	connect("button_down", play_key)

func play_key() -> void:
	emit_signal("key_pressed",self)
