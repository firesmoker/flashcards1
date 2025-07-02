class_name NoteOnStaff extends NoteElement
@onready var stem_axis: Control = $NoteDisplay/NoteImage/StemAxis
@onready var note_image: TextureRect = $NoteDisplay/NoteImage
var note_y_position: float = 241
var note_step_size: float = 22.5
var notes_locations: Dictionary = {"A4":5,"B4":6,"C4":0,"D4":1,"E4":2,"F4":3,"G4":4,}
@onready var helper_line: TextureRect = $NoteDisplay/NoteImage/HelperLine
var stem_reverse_location_threshold: int
@onready var staff: Control = $NoteDisplay/Staff


#func change_note(new_note: String) -> void:
	#note = new_note

func _ready() -> void:
	position_staff_lines()
	stem_reverse_location_threshold = notes_locations["B4"]

func position_staff_lines() -> void:
	var line_y_position: float = 0
	for line: TextureRect in staff.get_children():
		line.position.y = line_y_position
		line_y_position += note_step_size * 2

func play_success_effects() -> void:
	modulate = Color.GREEN
	await get_tree().create_timer(0.5).timeout
	modulate = Color.WHITE

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
	note_image.position.y -= notes_locations[new_note]*note_step_size
	#print(notes_locations[current_note])
	if new_note == "C4":
		helper_line.visible = true
	else:
		helper_line.visible = false


func set_stem_rotation(new_note: String) -> void:
	if notes_locations[new_note] >= stem_reverse_location_threshold:
		flip_stem(true)
	else:
		flip_stem(false)
