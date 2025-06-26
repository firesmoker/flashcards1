class_name GameManager extends Node2D
var current_note: String = "A"
var recieved_note: String
var notes_bank: Array[String] = ["A4","B4","C4","D4","E4","F4","G4",]
var notes_locations: Dictionary = {"A4":5,"B4":6,"C4":0,"D4":1,"E4":2,"F4":3,"G4":4,}
var stem_reverse_location_threshold: int
var note_step_size: float = 22.5
var note_y_position: float = 245
var current_score: int = 0
var success_time_bonus: float = 2
var success_score_bonus: float = 5
static var max_score: int = 0
var level_timer: float = 5
@onready var score_label: Label = $"../UI/ScoreLabel"
@onready var timer_label: Label = $"../UI/Background/TimerLabel"
@onready var staff: Control = $"../UI/NoteDisplay/Staff"
@onready var note_display: Panel = $"../UI/NoteDisplay"
@onready var note_name: Label = $"../UI/NoteDisplay/NoteName"
@onready var note_buttons: Control = $"../UI/Background/NoteButtons"
@onready var note_image: TextureRect = $"../UI/NoteDisplay/NoteImage"
@onready var game_over_overlay: Panel = $"../UI/GameOverOverlay"

var current_note_buttons: Array
signal ready_for_next_level
signal success
signal fail
@onready var helper_line: TextureRect = $"../UI/NoteDisplay/NoteImage/HelperLine"
@onready var stem_axis: Control = $"../UI/NoteDisplay/NoteImage/StemAxis"
@onready var audio: AudioStreamPlayer2D = $"../Audio"

func _ready() -> void:
	current_note_buttons = note_buttons.get_children()
	note_buttons.size.x = get_viewport_rect().size.x / 2
	if note_buttons.size.x < get_combined_buttons_width():
		note_buttons.size.x = get_combined_buttons_width()
	note_buttons.position.x = (get_viewport_rect().size.x - note_buttons.size.x) / 2
	game_over_overlay.visible = false
	score_label.text = "Score: 0"
	stem_reverse_location_threshold = notes_locations["B4"]
	#ProjectSettings.set_setting("display/window/handheld/orientation", "portrait")
	#DisplayServer.screen_set_orientation(DisplayServer.ScreenOrientation.SCREEN_LANDSCAPE)
	set_level(create_random_level_notes())

func get_combined_buttons_width() -> float:
	var combined_width: float = 0
	for button: Button in current_note_buttons:
		combined_width += button.size.x
	print(combined_width)
	return combined_width

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		var key_pressed: String = OS.get_keycode_string(event.keycode)
		print("A key was pressed: ", key_pressed)
		var note_value: String = key_pressed + "4"
		get_user_input(note_value)

func _process(delta: float) -> void:
	update_timer(delta)
	success_time_bonus *= 0.9997
	#print(success_time_bonus)

func update_timer(delta: float) -> void:
	level_timer -= delta
	var display_timer: int = round_up(level_timer)
	if display_timer < 0:
		display_timer = 0
	timer_label.text = "Time: " + var_to_str(display_timer)
	#print(level_timer)
	if level_timer <= 0:
		game_over()


func round_up(num: float) -> float:
	var new_num: float = round(num)
	if new_num < num:
		return new_num + 1
	else:
		return new_num

func game_over() -> void:
	game_over_overlay.visible = true

func scan_buttons_for_matching_input(note: String) -> void:
	for button: Button in current_note_buttons:
		if button is NoteButton:
			if button._note == note:
				pass
		pass

func update_score(points: int) -> void:
	current_score += points
	score_label.text = "Score: " + var_to_str(current_score)
	if max_score < current_score:
		max_score = current_score
	
func change_level_note(new_note: String) -> void:
	current_note = new_note
	note_name.text = current_note[0]
	position_note()
	

func toggle_note_name(toggle: bool) -> void:
	note_name.visible = toggle
	note_image.visible = !toggle
	staff.visible = !toggle

func flip_stem(toggle: bool) -> void:
	if toggle:
		stem_axis.rotation = deg_to_rad(180)
	else:
		stem_axis.rotation = 0

func set_stem_rotation() -> void:
	if notes_locations[current_note] >= stem_reverse_location_threshold:
		flip_stem(true)
	else:
		flip_stem(false)

func position_note() -> void:
	note_image.position.y = note_y_position + note_step_size
	set_stem_rotation()
	note_image.position.y -= notes_locations[current_note]*note_step_size
	#print(notes_locations[current_note])
	if current_note == "C4":
		helper_line.visible = true
	else:
		helper_line.visible = false

func determine_success(button_pressed: Button = null) -> bool:
	if recieved_note == current_note:
		audio.stream = audio.get_sound("click")
		audio.play()
		if button_pressed:
			emit_signal("success",true, button_pressed)
		update_score(success_score_bonus)
		level_timer += success_time_bonus
		#print("success!")
		flash_color(Color.GREEN)
		return true
	else:
		audio.stream = audio.get_sound("wrong")
		audio.play()
		emit_signal("success",false, button_pressed)
		#print("fail!")
		flash_color(Color.RED)
		return false

func disable_buttons(disabled: bool = true) -> void:
	for button: Button in current_note_buttons:
		if disabled:
			button.disabled = true
			button.mouse_filter = Control.MOUSE_FILTER_IGNORE
		else:
			button.disabled = false
			button.mouse_filter = Control.MOUSE_FILTER_STOP
			

func get_user_input(selected_note: String, button_pressed: Button = null) -> void:
	#print(button_pressed)
	toggle_note_name(true)
	disable_buttons()
	recieved_note = selected_note
	determine_success(button_pressed)
	await ready_for_next_level
	disable_buttons(false)
	set_level(create_random_level_notes())


func set_level(level_array: Array[String]) -> void:
	toggle_note_name(false)
	var new_note: String = level_array[randi_range(0,level_array.size()-1)]
	while new_note == current_note:
		print("re randomizing, same note!")
		new_note = level_array[randi_range(0,level_array.size()-1)]
	change_level_note(new_note)
	change_level_note_buttons(level_array)

func change_level_note_buttons(notes_array: Array[String]) -> void:
	var number_of_buttons: int = notes_array.size()
	for i in range(0,number_of_buttons):
		var random_note_index: int = randi_range(0,notes_array.size()-1)
		var new_note: String = notes_array[random_note_index]
		#print("changing button: " + current_note_buttons[i].name + "to new note: " + new_note)
		current_note_buttons[i].change_note(new_note)
		notes_array.pop_at(random_note_index)

func create_random_level_notes(number_of_buttons: int = 3) -> Array[String]:
	var temporary_notes_bank: Array[String] = notes_bank.duplicate()
	var level_notes: Array[String]
	for i in range(0,number_of_buttons):
		var random_note_index: int = randi_range(0,temporary_notes_bank.size()-1)
		level_notes.append(temporary_notes_bank[random_note_index])
		temporary_notes_bank.pop_at(random_note_index)
	return level_notes

func flash_color(new_color: Color = Color.GREEN, time: float = 0.5) -> void:
	note_display.modulate = new_color
	await get_tree().create_timer(time).timeout
	emit_signal("ready_for_next_level")
	note_display.modulate = Color.WHITE
	
