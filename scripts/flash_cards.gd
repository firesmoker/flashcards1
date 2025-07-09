class_name FlashCards extends GameType

@onready var note_on_staff: NoteElement = $"../FlashCards/GameUI/NoteOnStaff"
@onready var timer_bar: ProgressBar = $"../FlashCards/GameUI/TimerBar"
@onready var timer_label: Label = $"../FlashCards/GameUI/TimerLabel"
@onready var staff: Control = $"../FlashCards/GameUI/NoteOnStaff/NoteDisplay/Staff"
@onready var note_name: Label = $"../FlashCards/GameUI/NoteOnStaff/NoteDisplay/NoteName"
@onready var note_buttons: Control = $"../FlashCards/GameUI/NoteButtons"
@onready var note_image: TextureRect = $"../FlashCards/GameUI/NoteOnStaff/NoteDisplay/NoteImage"
@onready var game_over_overlay: Panel = $"../FlashCards/GameUI/GameOverOverlay"
@onready var restart_button: Button = $"../FlashCards/GameUI/GameOverOverlay/RestartButton"
@onready var score_label: Label = $"../FlashCards/GameUI/ScoreLabel"
var recieved_note: String

func _ready() -> void:
	await get_tree().process_frame
	initialize_ui()
	set_flash_cards_level(create_random_level_notes())
	choose_element(note_on_staff)

func _process(delta: float) -> void:
	update_timer(delta)

func set_flash_cards_level(level_array: Array[String]) -> void:
	print("all ready")
	toggle_note_name(false)
	var new_note: String = level_array[randi_range(0,level_array.size()-1)]
	while new_note == note_on_staff.note:
		print("re randomizing, same note!")
		new_note = level_array[randi_range(0,level_array.size()-1)]
	change_level_note(new_note)
	change_level_note_buttons(level_array)
	input_enabled = true

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


func initialize_ui() -> void:
	#set_ui_theme("dark")
	input_enabled = true
	check_orientation()
	organize_ui_buttons()
	game_over_overlay.visible = false
	score_label.text = "Score: 0"
	
	
func organize_ui_buttons(landscape: bool = true) -> void:
	current_note_buttons = note_buttons.get_children()
	note_buttons.size.x = get_viewport_rect().size.x / 2
	if note_buttons.size.x < get_combined_buttons_width():
		note_buttons.size.x = get_combined_buttons_width()
	note_buttons.position.x = (get_viewport_rect().size.x - note_buttons.size.x) / 2


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
		print(chosen_element2.source)
		if chosen_element2.source is NoteButton:
			print("element is button")
			emit_signal("success",true,chosen_element2.source)
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


func change_level_note_buttons(notes_array: Array[String]) -> void:
	var number_of_buttons: int = notes_array.size()
	print (number_of_buttons)
	for i in range(0,number_of_buttons):
		var random_note_index: int = randi_range(0,notes_array.size()-1)
		var new_note: String = notes_array[random_note_index]
		#print("changing button: " + current_note_buttons[i].name + "to new note: " + new_note)
		#print("new note for button: "  + new_note)
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
