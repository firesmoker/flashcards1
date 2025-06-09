extends Node2D
var current_note: String = "A"
var recieved_note: String
var notes_bank: Array[String] = ["A","B","C","D","E","F","G",]
@onready var note_display: Panel = $"../UI/NoteDisplay"
@onready var note_name: Label = $"../UI/NoteDisplay/NoteName"
@onready var note_buttons: Control = $"../UI/NoteButtons"
var current_note_buttons: Array
signal ready_for_next_level

func _ready() -> void:
	current_note_buttons = note_buttons.get_children()
	set_level(create_random_level_notes())

	
func change_level_note(new_note: String) -> void:
	current_note = new_note
	note_name.text = current_note
	

func determine_success() -> bool:
	if recieved_note == current_note:
		print("success!")
		flash_color(Color.GREEN)
		return true
	else:
		print("fail!")
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
			

func get_user_input(selected_note: String) -> void:
	disable_buttons()
	recieved_note = selected_note
	determine_success()
	await ready_for_next_level
	disable_buttons(false)
	set_level(create_random_level_notes())


func set_level(level_array: Array[String]) -> void:
	change_level_note(level_array[randi_range(0,level_array.size()-1)])
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
