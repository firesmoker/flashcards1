class_name NoteButton extends Button

#var note: String = "A"
signal note_pressed
@onready var game_manager: GameManager = %GameManager
#@onready var audio: Audio = $"../../../Audio"
var click_sound: AudioStream
var wrong_sound: AudioStream
var success_texture: Texture2D
var success_stylebox: StyleBox
var note_element: NoteElement = NoteElement.new()
@onready var current_game: GameType

func _ready() -> void:
	note_element.source = self
	#print(note_element.source)
	#success_texture = preload("res://button_success_texture.tres")
	#success_stylebox = preload("res://button_style_box.tres")
	#theme.set_stylebox("disabled","Button",success_stylebox)
	#click_sound = preload("res://click2.wav")
	#wrong_sound = preload("res://wrong1.wav")
	connect_to_current_game()
	#connect("note_pressed",game_manager.get_user_input_new)
	#connect("button_up",press_button)
	#connect("button_down",press_down_button)
	

func connect_to_current_game() -> void:
	match game_manager.current_game:
		"flash_cards": 
			current_game = get_node("/root/Game/FlashCards")
			connect("note_pressed",current_game.get_user_input_new)
			connect("button_up",press_button)
			connect("button_down",press_down_button)
			current_game.success.connect(flash_by_success)

func change_note(new_note: String = "F") -> void:
	note_element.note = new_note
	#note = new_note
	text = note_element.note[0]
	modulate = Color.WHITE

func press_button() -> void:
	#emit_signal("note_pressed",note, self)
	#print("chosen note in button " + note_element.note)
	emit_signal("note_pressed",note_element.note, note_element)
	
func press_down_button() -> void:
	Input.vibrate_handheld(10)
	current_game.play_note(note_element.note)

func flash_by_success(success: bool, source: Variant)-> void:
	print(source.name + ", compared to button: " + self.name + " " + str(self.get_path()))
	if source == self:
		if success:
			print("successful button: " + self.name)
			#print(NoteElement.notes_properties[note_element.note]["color"])
			flash_color(NoteElement.notes_properties[note_element.note]["color"])
			#audio.stream = audio.get_sound("click")
			#audio.play()
		else:
			flash_color(Color.RED)
			#audio.stream = audio.get_sound("wrong")
			#audio.play()
	else:
		pass
		#flash_color(Color(0,0,0,0.5))

func flash_color(new_color: Color = Color.GREEN, time: float = 0.5) -> void:
	#add_theme_stylebox_override("disabled",success_stylebox)
	#remove_theme_stylebox_override("disabled")
	#if has_theme_stylebox_override("disabled"):
		#get_theme_stylebox("disabled").bg_color = new_color
	print("flashing color")
	self.modulate = new_color
	await get_tree().create_timer(time).timeout
	self.modulate = Color.WHITE
	#if has_theme_stylebox_override("disabled"):
		#get_theme_stylebox("disabled").bg_color = Color.WHITE
