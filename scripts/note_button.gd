class_name NoteButton extends Button

var _note: String = "A"
signal note_pressed
@onready var game_manager: GameManager = %GameManager
@onready var audio: Audio = $"../../../Audio"
var click_sound: AudioStream
var wrong_sound: AudioStream

func _ready() -> void:
	#click_sound = preload("res://click2.wav")
	#wrong_sound = preload("res://wrong1.wav")
	connect("note_pressed",game_manager.get_user_input)
	connect("button_up",press_button)
	game_manager.success.connect(flash_by_succes)

func change_note(new_note: String = "F") -> void:
	_note = new_note
	text = _note[0]

func press_button() -> void:
	emit_signal("note_pressed",_note, self)
	

func flash_by_succes(success: bool, button_pressed: Button) -> void:
	if button_pressed == self:
		if success:
			flash_color(Color.GREEN)
			#audio.stream = audio.get_sound("click")
			#audio.play()
		else:
			flash_color(Color.RED)
			#audio.stream = audio.get_sound("wrong")
			#audio.play()

func flash_color(new_color: Color = Color.GREEN, time: float = 0.5) -> void:
	self.modulate = new_color
	await get_tree().create_timer(time).timeout
	self.modulate = Color.WHITE
