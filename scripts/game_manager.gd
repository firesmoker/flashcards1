class_name GameManager extends Node2D
var current_note: String = "A"
var recieved_note: String
var notes_bank: Array[String] = ["A","B","C","D","E","F","G",]
var notes_locations: Dictionary = {"A":5,"B":6,"C":0,"D":1,"E":2,"F":3,"G":4,}
var note_step_size: float = 22.5
var note_y_position: float = 245
@onready var staff: Control = $"../UI/NoteDisplay/Staff"
@onready var note_display: Panel = $"../UI/NoteDisplay"
@onready var note_name: Label = $"../UI/NoteDisplay/NoteName"
@onready var note_buttons: Control = $"../UI/NoteButtons"
@onready var note_image: TextureRect = $"../UI/NoteDisplay/NoteImage"
var current_note_buttons: Array
signal ready_for_next_level
signal success
signal fail

func _ready() -> void:
	#DisplayServer.screen_set_orientation(DisplayServer.ScreenOrientation.SCREEN_LANDSCAPE)
	current_note_buttons = note_buttons.get_children()
	set_level(create_random_level_notes())

	
func change_level_note(new_note: String) -> void:
	current_note = new_note
	note_name.text = current_note
	position_note()
	

func toggle_note_name(toggle: bool) -> void:
	note_name.visible = toggle
	note_image.visible = !toggle
	staff.visible = !toggle
	

func position_note() -> void:
	note_image.position.y = note_y_position + note_step_size
	note_image.position.y -= notes_locations[current_note]*note_step_size
	print(notes_locations[current_note])

func determine_success(button_pressed: Button) -> bool:
	if recieved_note == current_note:
		emit_signal("success",true, button_pressed)
		#print("success!")
		flash_color(Color.GREEN)
		return true
	else:
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
			

func get_user_input(selected_note: String, button_pressed: Button) -> void:
	print(button_pressed)
	toggle_note_name(true)
	disable_buttons()
	recieved_note = selected_note
	determine_success(button_pressed)
	await ready_for_next_level
	disable_buttons(false)
	set_level(create_random_level_notes())


func set_level(level_array: Array[String]) -> void:
	toggle_note_name(false)
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
