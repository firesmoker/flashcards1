class_name NoteButton extends Button

var _note: String = "A"
signal note_pressed
@onready var game_manager: GameManager = %GameManager

func _ready() -> void:
	connect("note_pressed",game_manager.get_user_input)
	connect("button_up",press_button)
	game_manager.success.connect(flash_by_succes)

func change_note(new_note: String = "F") -> void:
	_note = new_note
	text = _note

func press_button() -> void:
	emit_signal("note_pressed",_note, self)

func flash_by_succes(success: bool, button_pressed: Button) -> void:
	if button_pressed == self:
		if success:
			flash_color(Color.GREEN)
		else:
			flash_color(Color.RED)

func flash_color(new_color: Color = Color.GREEN, time: float = 0.5) -> void:
	self.modulate = new_color
	await get_tree().create_timer(time).timeout
	self.modulate = Color.WHITE
