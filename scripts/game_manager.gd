class_name GameManager extends Node2D
@onready var flash_cards: GameType = $"../FlashCards"

var dark_background: Color = Color(0.078,0.122,0.141)
#var light_background: Color = Color(1,1,0.992)
var light_background: Color = Color.REBECCA_PURPLE
var dark_theme_note_color: Color = Color(1,1,0.992)
var light_theme_note_color: Color = Color(0.078,0.122,0.141)
var dark_theme_staff_color: Color = Color(1,1,0.992,0.55)
var light_theme_staff_color: Color = Color(0.078,0.122,0.141,0.55)
var mode: Array[String] = ["level_timer","note_timer"]
@onready var timer_bar: ProgressBar = $"../FlashCards/GameUI/TimerBar"
@onready var background: Panel = $"../GeneralUI/Background"

var recieved_note: String
var notes_bank: Array[String] = ["A4","B4","C4","D4","E4","F4","G4",]
var current_score: int = 0
var success_time_bonus: float = 1
var success_score_bonus: float = 10
var success_display_time: float = 0.5
static var max_score: int = 0
var level_timer: float = 20
var max_level_timer: float = 20
var input_enabled: bool = true
var timer_paused: bool = false
@onready var note_on_staff: NoteElement = $"../FlashCards/GameUI/NoteOnStaff"

@onready var timer_label: Label = $"../FlashCards/GameUI/TimerLabel"
@onready var staff: Control = $"../FlashCards/GameUI/NoteOnStaff/NoteDisplay/Staff"
@onready var note_name: Label = $"../FlashCards/GameUI/NoteOnStaff/NoteDisplay/NoteName"
@onready var note_buttons: Control = $"../FlashCards/GameUI/NoteButtons"
@onready var note_image: TextureRect = $"../FlashCards/GameUI/NoteOnStaff/NoteDisplay/NoteImage"
@onready var game_over_overlay: Panel = $"../FlashCards/GameUI/GameOverOverlay"
@onready var restart_button: Button = $"../FlashCards/GameUI/GameOverOverlay/RestartButton"
@onready var score_label: Label = $"../FlashCards/GameUI/ScoreLabel"

var first_flash_cards_run: bool = true
var chosen_element1: NoteElement
var chosen_element2: NoteElement
var current_note_buttons: Array
signal ready_for_next_level
signal success
signal fail
signal change_theme
@onready var helper_line: TextureRect = $"../FlashCards/GameUI/NoteOnStaff/NoteDisplay/NoteImage/HelperLine"
@onready var stem_axis: Control = $"../FlashCards/GameUI/NoteOnStaff/NoteDisplay/NoteImage/StemAxis"
@onready var audio: AudioStreamPlayer2D = $"../FlashCards/Audio"

func _ready() -> void:
	initialize_ui()
	set_flash_cards_level(create_random_level_notes())
	choose_element(note_on_staff)

func _process(delta: float) -> void:
	update_timer(delta)
	#adjust_success_time_bonus(delta)

func initialize_ui() -> void:
	set_ui_theme("light")
	input_enabled = true
	check_orientation()
	organize_ui_buttons()
	game_over_overlay.visible = false
	score_label.text = "Score: 0"

func adjust_success_time_bonus(delta: float) -> void:
	success_time_bonus *= 0.9997 * delta
	if success_time_bonus <= success_display_time:
		success_time_bonus = success_display_time

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and input_enabled:
		var key_pressed: String = OS.get_keycode_string(event.keycode)
		match key_pressed:
			"A":
				pass
			"B":
				pass
			"C":
				pass
			"D":
				pass
			"E":
				pass
			"F":
				pass
			"G":
				pass
			_:
				return
		print("A key was pressed: ", key_pressed)
		var note_value: String = key_pressed + "4"
		play_note(note_value)
		get_user_input(note_value)

func _notification(what: Variant) -> void:
	if what == NOTIFICATION_WM_SIZE_CHANGED:
		check_orientation()

func check_orientation() -> bool:
	var size: Vector2 = get_viewport().get_visible_rect().size
	if size.y > size.x:
		print("Now in Portrait")
		return true
	else:
		print("Now in Landscape")
		return false

func organize_ui_buttons(landscape: bool = true) -> void:
	current_note_buttons = note_buttons.get_children()
	note_buttons.size.x = get_viewport_rect().size.x / 2
	if note_buttons.size.x < get_combined_buttons_width():
		note_buttons.size.x = get_combined_buttons_width()
	note_buttons.position.x = (get_viewport_rect().size.x - note_buttons.size.x) / 2

func get_combined_buttons_width() -> float:
	var combined_width: float = 0
	for button: Button in current_note_buttons:
		combined_width += button.size.x
	#print(combined_width)
	return combined_width


func set_ui_theme(theme: String = "light") -> void:
	match theme:
		"light":
			background.self_modulate = light_background
			emit_signal("change_theme","light")
		"dark":
			background.self_modulate = dark_background
			emit_signal("change_theme","dark")


func update_timer(delta: float, round: bool = true) -> void:
	if not timer_paused:
		level_timer -= delta
	var display_timer: int = round_up(level_timer)
	if display_timer < 0:
		display_timer = 0
	#timer_label.text = "Time: " + var_to_str(display_timer)
	timer_bar.value = display_timer
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
	input_enabled = false
	game_over_overlay.visible = true


func update_score(points: int) -> void:
	current_score += points
	score_label.text = "Score: " + var_to_str(current_score)
	if max_score < current_score:
		max_score = current_score
	
func change_level_note(new_note: String) -> void:
	#note_on_staff.note = new_note
	#note_name.text = note_on_staff.note[0]
	note_on_staff.change_note(new_note)
	

func toggle_note_name(toggle: bool) -> void:
	note_name.visible = toggle
	note_image.visible = !toggle
	staff.visible = !toggle

func determine_success(button_pressed: Button = null) -> bool:
	if recieved_note == note_on_staff.note:
		emit_signal("success",true, button_pressed)
		update_score(success_score_bonus)
		level_timer += success_time_bonus
		if level_timer >= max_level_timer:
			level_timer = max_level_timer
		note_on_staff.play_success_effects()
		await get_tree().create_timer(success_display_time).timeout
		emit_signal("ready_for_next_level")
		return true
	else:
		emit_signal("success",false, button_pressed)
		note_on_staff.play_failure_effects()
		await get_tree().create_timer(success_display_time).timeout
		emit_signal("ready_for_next_level")
		return false

func determine_success_new() -> void:
	if compare_elements():
		print("compare elements successful " + chosen_element1.note + " " + chosen_element2.note)
		#emit_signal("success",true, button_pressed)
		update_score(success_score_bonus)
		level_timer += success_time_bonus
		if level_timer >= max_level_timer:
			level_timer = max_level_timer
		note_on_staff.play_success_effects()
		await get_tree().create_timer(success_display_time).timeout
		emit_signal("ready_for_next_level")
	else:
		print("compare elements not successful " + chosen_element1.note + " " + chosen_element2.note)
		#emit_signal("success",false, button_pressed)
		note_on_staff.play_failure_effects()
		await get_tree().create_timer(success_display_time).timeout
		emit_signal("ready_for_next_level")

func choose_element(element: NoteElement) -> void:
	print("choose_element")
	if not chosen_element1:
		chosen_element1 = element
		print("choosing_element1")
	elif not chosen_element2:
		chosen_element2 = element
		print("choosing_element2")
	else:
		print("two elements already chosen")
		
func compare_elements() -> bool:
	if chosen_element1.note == chosen_element2.note:
		return true
	else:
		return false



func disable_buttons(disabled: bool = true) -> void:
	for button: Button in current_note_buttons:
		if disabled:
			button.disabled = true
			button.mouse_filter = Control.MOUSE_FILTER_IGNORE
		else:
			button.disabled = false
			button.mouse_filter = Control.MOUSE_FILTER_STOP
			

func get_user_input_new(new_note: String, element: NoteElement) -> void:
	print("get_user_input_new" + element.name)
	choose_element(element)
	if chosen_element1 and chosen_element2:
		print("comparing elements")
		determine_success_new()
		await ready_for_next_level
		timer_paused = false
		disable_buttons(false)
		clear_elements()
		set_flash_cards_level(create_random_level_notes())
		choose_element(note_on_staff)
	else:
		print("no two chosen elements " + chosen_element1.name + " " + chosen_element2.name)

func clear_elements() -> void:
	chosen_element1 = null
	chosen_element2 = null

func start_game(game: String) -> void:
	pass

func get_user_input(selected_note: String, button_pressed: Button = null) -> void:
	input_enabled = false
	disable_buttons()
	recieved_note = selected_note
	#play_note(recieved_note)
	timer_paused = true
	determine_success(button_pressed)
	await ready_for_next_level
	timer_paused = false
	disable_buttons(false)
	set_flash_cards_level(create_random_level_notes())


func play_note(note: String) -> void:
	var octave: String = note[1]
	print(octave)
	var note_name: String = note[0]
	print(note_name)
	audio.stream = load("res://audio/"+octave+"-"+note_name+".ogg")
	audio.play()

func set_flash_cards_level(level_array: Array[String]) -> void:
	if first_flash_cards_run:
		await flash_cards.ready
		first_flash_cards_run = false
	print("all ready")
	toggle_note_name(false)
	var new_note: String = level_array[randi_range(0,level_array.size()-1)]
	while new_note == note_on_staff.note:
		print("re randomizing, same note!")
		new_note = level_array[randi_range(0,level_array.size()-1)]
	change_level_note(new_note)
	change_level_note_buttons(level_array)
	input_enabled = true

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
	
func restart_game() -> void:
	get_tree().reload_current_scene()
