class_name NoteElement extends Control

##C is red, D is orange, E is yellow, F is green, G is light blue, A is blue, and B is violet,

static var notes_properties: Dictionary = {
	"A4":{"location":5,"color": Color(0,0.697,0.697)},
	"B4":{"location":6,"color": Color(0,0.697,0.697)},
	"C4":{"location":0,"color": Color.MEDIUM_PURPLE},
	"D4":{"location":1,"color": Color(0,0.697,0.697)},
	"E4":{"location":2,"color": Color(0,0.697,0.697)},
	"F4":{"location":3,"color": Color(0,0.697,0.697)},
	"G4":{"location":4,"color": Color(0,0.697,0.697)},
}
static var stem_reverse_location_threshold: int

var note: String
@onready var game_manager: GameManager = %GameManager

func _ready() -> void:
	pass

func change_note(new_note: String) -> void:
	note = new_note

func play_success_effects() -> void:
	pass

func set_element_theme(theme: String = "light") -> void:
	match theme:
		"light":
			pass
		"dark":
			pass

#func position_note(new_note: String) -> void:
	#pass
