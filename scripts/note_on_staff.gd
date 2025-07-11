class_name NoteOnStaff extends NoteElement
@onready var stem_axis: Control = $NoteDisplay/NoteImage/StemAxis
@onready var note_image: TextureRect = $NoteDisplay/NoteImage
var note_y_position: float = 241
var note_step_size: float = 22.5
#var notes_locations: Dictionary = {"A4":5,"B4":6,"C4":0,"D4":1,"E4":2,"F4":3,"G4":4,}
@onready var helper_line: TextureRect = $NoteDisplay/NoteImage/HelperLine
@onready var staff: Control = $NoteDisplay/Staff
@onready var note_display: Panel = $NoteDisplay
@onready var stem: TextureRect = $NoteDisplay/NoteImage/StemAxis/Stem


func change_note_color(color: Color) -> void:
	note_image.self_modulate = color
	stem.self_modulate = color
	helper_line.self_modulate = color

func change_note(new_note: String) -> void:
	note = new_note
	position_note(new_note)

func _ready() -> void:
	stem_reverse_location_threshold = notes_properties["B4"]["location"]
	position_staff_lines()
	game_manager.change_theme.connect(set_element_theme)

func position_staff_lines() -> void:
	var line_y_position: float = 0
	for line: TextureRect in staff.get_children():
		line.position.y = line_y_position
		line_y_position += note_step_size * 2



func set_element_theme(theme: String = "light") -> void:
	match theme:
		"light":
			print(self.name + " set to light theme")
			#note_display.self_modulate = game_manager.light_background
			note_display.self_modulate = Color.WHITE
			#note_image.modulate = game_manager.light_theme_note_color
			set_note_color(game_manager.light_theme_note_color)
			staff.modulate = game_manager.light_theme_staff_color
		"dark":
			print(self.name + " set to light theme")
			note_display.self_modulate = game_manager.dark_background
			#note_image.modulate = game_manager.dark_theme_note_color
			set_note_color(game_manager.dark_theme_note_color)
			staff.modulate = game_manager.dark_theme_staff_color

func set_note_color(color: Color = Color.BLACK) -> void:
	note_image.self_modulate = color
	stem.self_modulate = color
	helper_line.self_modulate = color

func play_success_effects() -> void:
	change_note_color(notes_properties[note]["color"])
	await get_tree().create_timer(0.5).timeout
	change_note_color(Color.BLACK)

func play_failure_effects() -> void:
	modulate = Color.RED
	await get_tree().create_timer(0.5).timeout
	modulate = Color.WHITE

func flip_stem(toggle: bool) -> void:
	if toggle:
		stem_axis.rotation = deg_to_rad(180)
	else:
		stem_axis.rotation = 0

func position_note(new_note: String) -> void:
	note_image.position.y = note_y_position + note_step_size
	set_stem_rotation(new_note)
	note_image.position.y -= notes_properties[new_note]["location"]*note_step_size
	#print(notes_locations[current_note])
	if new_note == "C4":
		helper_line.visible = true
	else:
		helper_line.visible = false


func set_stem_rotation(new_note: String) -> void:
	print(stem_reverse_location_threshold)
	if notes_properties[new_note]["location"] >= stem_reverse_location_threshold:
		flip_stem(true)
	else:
		flip_stem(false)
