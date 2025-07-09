class_name GameType extends Node2D

@export var game_name: String

var dark_background: Color = Color(0.078,0.122,0.141)
#var light_background: Color = Color(1,1,0.992)
var light_background: Color = Color.REBECCA_PURPLE
var dark_theme_note_color: Color = Color(1,1,0.992)
var light_theme_note_color: Color = Color(0.078,0.122,0.141)
var dark_theme_staff_color: Color = Color(1,1,0.992,0.55)
var light_theme_staff_color: Color = Color(0.078,0.122,0.141,0.55)
var mode: Array[String] = ["level_timer","note_timer"]
@onready var background: Panel = $"../GeneralUI/Background"

#var recieved_note: String
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


var game_ui: CanvasLayer


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

#func _ready() -> void:
	#await get_tree().process_frame
	#initialize_ui()
	#set_flash_cards_level(create_random_level_notes())
	#choose_element(note_on_staff)
	

#func get_user_input() -> void:
	#pass

#func _process(delta: float) -> void:
	#update_timer(delta)
	##adjust_success_time_bonus(delta)



func toggle_visibility(toggle: bool = true) -> void:
	if not game_ui:
		var game_ui_path: String = "../" + game_name + "/GameUI"
		game_ui = get_node(game_ui_path)
	self.visible = toggle
	game_ui.visible = toggle

func adjust_success_time_bonus(delta: float) -> void:
	success_time_bonus *= 0.9997 * delta
	if success_time_bonus <= success_display_time:
		success_time_bonus = success_display_time

#func _input(event: InputEvent) -> void:
	#if event is InputEventKey and event.pressed and not event.echo and input_enabled:
		#var key_pressed: String = OS.get_keycode_string(event.keycode)
		#match key_pressed:
			#"A":
				#pass
			#"B":
				#pass
			#"C":
				#pass
			#"D":
				#pass
			#"E":
				#pass
			#"F":
				#pass
			#"G":
				#pass
			#_:
				#return
		#print("A key was pressed: ", key_pressed)
		#var note_value: String = key_pressed + "4"
		#play_note(note_value)
		#get_user_input(note_value)

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





func round_up(num: float) -> float:
	var new_num: float = round(num)
	if new_num < num:
		return new_num + 1
	else:
		return new_num





	


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




			

#func get_user_input_new(new_note: String, element: NoteElement) -> void:
	#print("get_user_input_new" + element.name)
	#choose_element(element)
	#if chosen_element1 and chosen_element2:
		#print("comparing elements")
		#determine_success_new()
		#await ready_for_next_level
		#timer_paused = false
		#disable_buttons(false)
		#clear_elements()
		#set_flash_cards_level(create_random_level_notes())
		#choose_element(note_on_staff)
	#else:
		#print("no two chosen elements " + chosen_element1.name + " " + chosen_element2.name)

func clear_elements() -> void:
	chosen_element1 = null
	chosen_element2 = null

func start_game(game: String) -> void:
	pass

#func get_user_input(selected_note: String, button_pressed: Button = null) -> void:
	#input_enabled = false
	#disable_buttons()
	#recieved_note = selected_note
	##play_note(recieved_note)
	#timer_paused = true
	#determine_success(button_pressed)
	#await ready_for_next_level
	#timer_paused = false
	#disable_buttons(false)
	#set_flash_cards_level(create_random_level_notes())


func play_note(note: String) -> void:
	print("note is " + note)
	var octave: String = note[1]
	print(octave)
	var note_name: String = note[0]
	print(note_name)
	audio.stream = load("res://audio/"+octave+"-"+note_name+".ogg")
	audio.play()




	
func restart_game() -> void:
	get_tree().reload_current_scene()
