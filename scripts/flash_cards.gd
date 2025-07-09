class_name FlashCards extends GameType

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
